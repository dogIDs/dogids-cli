require "open-uri"
require "open_uri_redirections"
require "progressbar"
require_relative "../../progress_bar"
require "thor"

module Codelation
  class Cli < Thor
  private

    # Install an Atom package
    # @param [String] package
    def apm_install(package)
      print_command("Installing #{package}")
      `/Applications/Atom.app/Contents/Resources/app/apm/bin/apm install #{package}`
    end

    # Install Atom.app Packages
    def install_atom_packages
      packages = %w(
        color-picker
        erb-snippets
        linter
        linter-csslint
        linter-erb
        linter-jshint
        linter-php
        linter-ruby
        linter-scss-lint
        remote-atom
      )
      packages.each do |package|
        apm_install(package)
      end
    end
  end
end
