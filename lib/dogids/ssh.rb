require "thor"
require_relative "ssh/development"
require_relative "ssh/production"
require_relative "ssh/staging"

module Dogids
  class Cli < Thor
    desc "ssh", "List available SSH commands"
    def ssh(vm_name = nil)
      case vm_name
      when "dev"
        ssh_dev(vm_name)
      when "staging"
        ssh_staging(vm_name)
      else
        puts "Development SSH Commands:"
        puts "  dogids ssh:dev dev            # SSH into local development VM"
        puts "  dogids ssh:dev lb             # SSH into local development LB"
        puts " "
        puts "Staging SSH Commands:"
        puts "  dogids ssh:staging lb         # SSH into staging LB"
        puts "  dogids ssh:staging staging    # SSH into staging Apache/PHP/MySQL VM"
        puts " "
        puts "Production SSH Commands:"
        puts "  dogids ssh:production lb      # SSH into production LB"
        puts "  dogids ssh:production railgun # SSH into production railgun instance"
        puts "  dogids ssh:production admin   # SSH into VM for long running admin processes"
        puts "  dogids ssh:production db      # SSH into production MySQL/Redis VM"
        puts "  dogids ssh:production web     # SSH into production Apache/PHP VM"
        puts "  dogids ssh:production worker  # SSH into production Ruby/Sidekiq VM"
        puts " "
      end
    end
  end
end
