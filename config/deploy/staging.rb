server "olivia.kolibria.com", :app, :web, :db, :primary => true
set(:deploy_to){ "/home/xyz/staging/www/" }
# set(:branch, fetch(:branch, "staging"))
set(:branch, fetch(:branch, "master")) # for demo-app simplicity we only use the branch master
set(:bundle_without){ [] }