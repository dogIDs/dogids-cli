require "thor"
require "user_config"

module Dogids
  class Cli < Thor
    desc "config", "Configure URLs/IP Addresses"
    def config(command = nil)
      # Commands
      case command
      when "list"
        list
      when "admin"
        set_config("admin")
      when "db"
        set_config("db")
      when "dev"
        set_config("dev")
      when "staging"
        set_config("staging")
      when "web"
        set_config("web")
      when "worker"
        set_config("worker")
      else
        puts " "
        puts "Config Commands:"
        puts " "
        puts "  dogids config list            # List all current configurations"
        puts " "
        puts "  dogids config admin           # Set URL/IP for Admin"
        puts "  dogids config db              # Set URL/IP for DB"
        puts "  dogids config dev             # Set URL/IP for Dev"
        puts "  dogids config staging         # Set URL/IP for Staging"
        puts "  dogids config web             # Set URL/IP for Web"
        puts "  dogids config worker          # Set URL/IP for Worker"
        puts " "
      end
    end

    no_commands do
      def list
        dogids_config = set_config_location
        if dogids_config.any? then
          say("The following configurations are set: \n \n")
          print_table(dogids_config)
        else
          say("No configuration values have been set. Here's the command list:")
          config
        end
      end

      def set_config(location)
        dogids_config = set_config_location
        current_value = ""
        if dogids_config.key?("#{location}") then
          current_value = dogids_config["#{location}"]
          say("Current #{location} URL/IP: #{current_value} \n","\e[32m")
          set_new = yes?("-------> Do you want to enter a new value?[no]")
          return if set_new != true
        end
        new_value = ask("Enter in a URL/IP for #{location}: ").strip
        if (new_value == "" || new_value == current_value )then
          say("Now you're just being silly. ")
          if (new_value == "") then
            say("In case it wasn't clear, you are supposed to set a value...")
            confirm_string = "REMOVE the old value"
          else
            say("You are literally about to change nothing")
            confirm_string = "literally do nothing"
          end
          confirm = yes?("-------> Do you want to #{confirm_string}?[no]")
          return if confirm != true
        end
        dogids_config["#{location}"] = new_value
        dogids_config.save
        say("The new URL/IP for #{location}: #{new_value}","\e[32m")
      end
    end

  end
end
