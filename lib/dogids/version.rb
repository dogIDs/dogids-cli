require "json"
require "open-uri"
require "thor"

module Dogids
  VERSION = "0.0.17"

  class Cli < Thor
    desc "update", "Update dogids-cli to latest version"
    def update
      command = "gem install dogids-cli"
      puts "Running #{command}"
      exec(command)
    end

    desc "version", "Show version information"
    def version
      gem_version = "v#{Dogids::VERSION}"

      # Grab the latest version of the RubyGem
      rubygems_json = open("https://rubygems.org/api/v1/gems/dogids-cli.json").read
      rubygems_version = "v#{JSON.parse(rubygems_json)['version'].strip}"

      upgrade_message = ""
      if gem_version != rubygems_version
        upgrade_message = " Run `dogids update` to install"
      end

      puts
      puts "Dogids CLI"
      puts "  Installed: #{gem_version}"
      puts "  Latest:    #{rubygems_version}#{upgrade_message}"
      puts
    end
  end
end
