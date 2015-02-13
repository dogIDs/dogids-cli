require "json"
require "net/http"
require "thor"

module Codelation
  class Cli < Thor
  private

    def print_heading(heading)
      puts "-----> #{heading}"
    end

    def print_command(command)
      puts "       #{command}"
    end

    def run_command(command)
      print_command(command)
      `#{command}`
    end
  end
end
