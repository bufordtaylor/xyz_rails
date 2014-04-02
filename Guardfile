guard :rspec, all_on_start: true, cmd: "spring rspec" do
  group :specs do
    watch(%r{^spec/.+_spec\.rb$})

    watch("app/controllers/application_controller.rb") do
      "spec/controllers"
    end

    watch(%r{^app/(.+)\.rb$}) do |m|
      "spec/#{m[1]}_spec.rb"
    end

    watch(%r{^app/(.*)(\.erb|\.haml)$}) do |m|
      ["spec/#{m[1]}#{m[2]}_spec.rb", "spec/features"]
    end

    watch(%r{^lib/(.+)\.rb$}) do |m|
      "spec/lib/#{m[1]}_spec.rb"
    end

    watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
      [
        "spec/routing/#{m[1]}_routing_spec.rb",
        "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
        "spec/acceptance/#{m[1]}_spec.rb"
      ]
    end
  end
end