require "thor"
require_relative "ssh/development"
require_relative "ssh/production"

module Dogids
  class Cli < Thor
    desc "ssh", "List available SSH commands"
    def ssh(vm_name = nil)
      if vm_name
        ssh_development(vm_name)
      else
        puts "Development SSH Commands:"
        puts "  dogids ssh dev               # SSH into local development VM"
        puts " "
        puts "Production SSH Commands:"
        puts "  dogids ssh:production db     # SSH into production MySQL/Redis VM"
        puts "  dogids ssh:production web    # SSH into production Apache/PHP VM"
        puts "  dogids ssh:production worker # SSH into production Ruby/Sidekiq VM"
        puts " "
      end
    end
  end
end
