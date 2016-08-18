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
      when "clear"
        if yes?("------->Remove all configurations? [no]")
          system("rm ~/.dogids/conf.yaml")
          puts " "
          say("All configurations removed","\e[31m")
          set_default_configuration
          puts " "
          list
        else
          say("Fine, I didn't want to remove anything anyway","\e[31m")
        end
      else
        puts " "
        puts "Config Commands:"
        puts " "
        puts " Use the following so set environments:"
        puts " dogids config:<environment> <machine>"
        puts " "
        puts "  dogids config list            # List all current configurations"
        puts " "
        puts "  dogids config:dev             # Set URL/IP for Development Machines"
        puts "  dogids config:production      # Set URL/IP for Production Machines"
        puts "  dogids config:staging         # Set URL/IP for Staging machines"
        puts " "
      end
    end

    no_commands do

      # Config dev environment
      # @param [string] location
      def config_dev(location = nil)
        location ? set_config("dev",location) : config
      end

      # Config staging environment
      # @param [string] location
      def config_staging(location = nil)
        location ? set_config("staging",location) : config
      end

      # Config production environment
      # @param [string] location
      def config_production(location = nil)
        location ? set_config("production",location) : config
      end

      def list
        dogids_config = set_config_location
        if dogids_config.any? then
          say("The following configurations are set: \n")
          dogids_config.each do |environment, locations|
            say("\n##### #{environment}")
            print_table(locations)
          end
        else
          say("No configuration values have been set. Here's the command list:")
          config
        end
      end

      # Set configuration files based on environment and location
      # @param [string] environment
      # @param [string] location
      def set_config(environment,location)
        dogids_config = set_config_location
        environment_configuration = Hash.new
        if dogids_config["#{environment}"]
          environment_configuration = dogids_config["#{environment}"].to_hash
        end
        current_value = ""
        if dogids_config["#{environment}"] != nil && dogids_config["#{environment}"]["#{location}"] != nil then
          current_value = get_config_url(environment, location)
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
        environment_configuration[location] = new_value
        dogids_config["#{environment}"] = environment_configuration
        dogids_config.save
        say("The new URL/IP for #{location}: #{new_value}","\e[32m")
      end

      def set_default_configuration
        dogids_config = set_config_location
        dogids_config["dev"] = {"lb"=>"55.55.55.20","dev"=>"55.55.55.30"}
        dogids_config.save
      end

    end
  end
end
