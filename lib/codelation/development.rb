require "open-uri"
require "open_uri_redirections"
require "progressbar"
require_relative "../progress_bar"
require "thor"

module Codelation
  class Cli < Thor
    desc "development:install", "Install the development tools used by Codelation"
    def development_install
      print_heading("Installing Atom.app")
      install_atom

      print_heading("Installing Atom Packages")
      install_atom_packages

      print_heading("Installing Dot Files")
      install_dot_files

      print_heading("Installing Postgres.app")
      install_postgres

      print_heading("Installing RVM")
      install_rvm
    end
  end
end
