require "thor"
require_relative "deploy/staging"
require_relative "deploy/web"
require_relative "deploy/worker"

module Dogids
  class Cli < Thor
    desc "deploy", "List available deployment commands"
    def deploy(app_name = nil)
      deploy_command = "deploy_#{app_name}"
      return self.send(deploy_command) if self.respond_to?(deploy_command)

      puts "Deployment Commands:"
      puts "  dogids deploy staging # Deploy the staging.dogids.com storefront"
      puts "  dogids deploy web     # Deploy the dogids.com storefront"
      puts "  dogids deploy worker  # Deploy the dogids-backgrounder app"
      puts " "
    end
  end
end
