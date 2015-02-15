require "json"
require "open-uri"
require "thor"

module Codelation
  VERSION = "0.0.2"

  class Cli < Thor
    desc "update", "Update codelation-cli to latest version"
    def update
      command = "gem install codelation-cli"
      puts "Running #{command}..."
      exec(command)
    end

    desc "version", "Show version information"
    def version
      gem_version = "v#{Codelation::VERSION}"

      # Grab the latest version of the RubyGem
      rubygems_json = open("https://rubygems.org/api/v1/gems/codelation-cli.json").read
      rubygems_version = "v#{JSON.parse(rubygems_json)['version'].strip}"

      upgrade_message = ""
      if gem_version != rubygems_version
        upgrade_message = " Run `codelation update` to install"
      end

      puts
      puts "Codelation CLI"
      puts "  Installed: #{gem_version}"
      puts "  Latest:    #{rubygems_version}#{upgrade_message}"
      puts
    end
  end
end
