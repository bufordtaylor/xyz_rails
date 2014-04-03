set :stages, %w(production staging)
set :default_stage, "staging"

require "capistrano/ext/multistage"
require "bundler/capistrano"
require "colored"

set :application, "xyz"
set :repository,  "git@github.com:christophemaximin/xyz_rails.git"

set :scm, :git
set :user, "xyz"
set :deploy_via, :remote_cache
set :use_sudo, false
set :normalize_asset_timestamps, false

set :skip_local_tests, fetch(:skip_local_tests, true)
set :skip_remote_tests, fetch(:skip_remote_tests, false)
set :skip_pull, fetch(:skip_pull, false)
set :force_assets_precompile, fetch(:force_assets_precompile, false)

before "deploy", "deploy:confirm_production_stage"

before "deploy", "deploy:git_pull"
before "deploy", "deploy:run_local_tests"
before "deploy", "deploy:git_push"
before "deploy", "deploy:setup"
after "deploy:update_code", "deploy:symlink_shared"
after "deploy:update_code", "deploy:run_remote_tests"
after "deploy:update_code", "db:migrate"
after "deploy:update_code", "assets:precompile"


namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  task :confirm_production_stage do
    if stage == :production
      warning_message = %(
  ========================================================================

    WARNING: You're about to perform actions on PRODUCTION servers
    The tests WON'T be runned before deploying

  ========================================================================
)

      puts warning_message.red

      answer = Capistrano::CLI.ui.ask("Do you wish to continue deploying on production servers? (y/n)").downcase
      unless answer == "yes" or answer == "y"
        logger.info "Cancelling deployment"
        exit
      end
    end
  end

  desc "Set up the shared database.yml"
  task :symlink_shared, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Pull changes from the remote Git repository, unless specified with skip_pull=true"
  task :git_pull, roles: :app do
    if skip_pull == true
      logger.info "Skipping git pull as requested"
    else
      # unless %x(git rev-parse --abbrev-ref HEAD).chomp =~ /^staging|production$/
      #   raise Capistrano::Error, "You must be on the \"staging\" or \"production\" branch before deploying, run `git checkout staging` or `git checkout production` and try again"
      # end

      run_locally "git pull #{fetch(:repository)} #{fetch(:branch)}"

      unless %x(git status --porcelain).chomp == ""
        puts
        puts %x(git status --porcelain).red


        answer = Capistrano::CLI.ui.ask("The listed files above aren't committed and their changes won't be deployed. Do you wish to continue? (y/n)").downcase
        unless answer == "yes" or answer == "y"
          logger.info "Cancelling deployment"
          exit
        end
      end
    end
  end

  desc "Push commits to the remote Git repository"
  task :git_push, roles: :app do
    run_locally "git push #{fetch(:repository)} #{fetch(:branch)}"
  end


  desc "Run tests in local unless specified with skip_local_tests=true"
  task :run_local_tests, roles: :app do
    if skip_local_tests == true
      logger.info "Skipping the running of tests as requested"
    else
      logger.info "Running tests locally, please wait ..."
      unless system "bundle exec rspec --format progress --fail-fast spec/ 2>/dev/null"
        logger.info "Tests failed. Run `bundle exec rspec spec/` to see what went wrong."
        exit
      else
        logger.info "Tests passed"
      end
    end
  end

  desc "[Only for staging] Run tests on the server unless specified with skip_remote_tests=true"
  task :run_remote_tests, roles: :app do
    if stage == :staging
      if skip_remote_tests == true
        logger.info "Skipping the running of tests as requested"
      else

        run "cd #{latest_release} && RAILS_ENV=test bundle exec rake db:drop"
        run "cd #{latest_release} && RAILS_ENV=test bundle exec rake db:create"
        run "cd #{latest_release} && RAILS_ENV=test bundle exec rake db:schema:load"
        run "cd #{latest_release} && RAILS_ENV=test bundle exec rake db:migrate"

        logger.info "Running tests remotely, please wait ..."
        run "cd #{latest_release} && bundle exec rspec --format documentation --fail-fast spec/"
      end
    end
  end

end

namespace :assets do

  desc "Locally compile the assets, compress and sends them remotely"
  task :precompile, roles: :web do
    from = source.next_revision(current_revision) rescue nil
    if force_assets_precompile || from.nil? || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ lib/assets/ app/assets/ config/application.rb config/environments/production.rb | wc -l").to_i > 0
      run_locally "bundle exec rake assets:clean && RAILS_ENV=production bundle exec rake assets:precompile"
      run_locally "cd public && tar -jcf assets.tar.bz2 assets"
      top.upload "public/assets.tar.bz2", "#{shared_path}", :via => :scp
      run "cd #{shared_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2"
      run_locally "rm public/assets.tar.bz2"
      run_locally "bundle exec rake assets:clean"
    else
      logger.info "Skipping asset precompilation because there were no asset changes"
    end

    # Copy files from shared assets folder, without all the manifests, except the newest one
    run ("rm -rf #{latest_release}/public/assets &&
          mkdir -p #{latest_release}/public/assets &&
          mkdir -p #{shared_path}/assets &&
          cp -r #{shared_path}/assets/* #{latest_release}/public/assets/ &&
          rm -f #{latest_release}/public/assets/manifest-*.json &&
          cp `ls -tr #{shared_path}/assets/manifest-*.json | tail -1` #{latest_release}/public/assets/")
  end
end

namespace :db do
  desc "Migrate production database"
  task :migrate, roles: :app do
    logger.info "Migrating the production database"

    run "cd #{latest_release} && RAILS_ENV=production bundle exec rake db:migrate >/dev/null"
  end

  desc "Populates the production database"
  task :seed, roles: :app do
    logger.info "Populating the production database"
    run "cd #{latest_release} && RAILS_ENV=production bundle exec rake db:seed"
  end
end

desc "Show deployed revision"
task :show_revision, roles: :app do
  run "cat #{current_path}/REVISION"
end

namespace :rails do
  desc "Open the rails console on one of the remote servers"
  task :console, roles: :app do
    hostname = find_servers_for_task(current_task).first
    exec "ssh -l #{user} #{hostname} -t 'source ~/.bashrc && cd #{current_path} && bundle exec rails console -e #{rails_env}'"
  end
end

# helpers

def run_remote_rake(rake_cmd)
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')
  cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end
