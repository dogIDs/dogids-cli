require "json"
require "net/http"
require "thor"
require "user_config"

module Dogids
  class Cli < Thor
    include Thor::Actions
    # Add the ablitity to print help for commands like:
    #   `dogids help development:install`
    # This would print help for the method:
    #   `development_install`
    # @param method [String]
    def help(method = nil)
      if method.to_s.split(":").length >= 2
        method = method.to_s.gsub(":", "_")
      elsif method.to_s == "run"
        method = "walk"
      end
      super
    end

    # Add the ablitity to run commands like:
    #   `dogids development:install`
    # This would run the defined method:
    #   `development_install`
    def method_missing(method, *args, &block)
      if method.to_s.split(":").length >= 2
        self.send(method.to_s.gsub(":", "_"), *args)
      elsif method.to_s == "run"
        self.walk(*args)
      else
        super
      end
    end

    # This is the directory where your templates should be placed.
    def self.source_root
      File.expand_path("../../../resources", __FILE__)
    end

  private

    # Get configuration for environment and location
    # @param [string] environment
    # @param [string] location (Optional)
    def get_config_url(environment, location = nil)
      config_file = set_config_location
      if location
        return config_file[environment][location] if config_file[environment].has_key?(location)
      elsif config_file.has_key?(environment)
        return config_file[environment]
      else
        say("URL/IP hasn't been set for #{location} \n")
        say("Please set this first by running: \n")
        say("dogids config:#{environment} #{location}","\e[32m")
        return false
      end
    end

    # Print a heading to the terminal for commands that are going to be run.
    # @param [String] heading
    def print_heading(heading)
      puts "-----> #{heading}"
    end

    # Print a message to the terminal about a command that's going to run.
    # @param [String] command
    def print_command(command)
      command.split("\n").each do |line|
        print_wrapped(line, indent: 7)
      end
    end

    # Run a command with Bash after first printing the command to the terminal.
    # @param [String] command
    def run_command(command)
      print_command(command)
      `#{command}`
    end

    # Access local configuration file
    def set_config_location
      config = UserConfig.new('.dogids')
      config['conf.yaml']
    end
  end
end
