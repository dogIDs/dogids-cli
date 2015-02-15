require "json"
require "net/http"
require "thor"

module Codelation
  class Cli < Thor
  private

    # Print a heading to the terminal for commands that are going to be run.
    # @param heading [String]
    def print_heading(heading)
      puts "-----> #{heading}"
    end

    # Print a message to the terminal about a command that's going to run.
    # @param command [String]
    def print_command(command)
      puts "       #{command}"
    end

    # Run a command with Bash after first printing the command to the terminal.
    # @param command [String]
    def run_command(command)
      print_command(command)
      `#{command}`
    end
  end
end
