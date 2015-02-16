require "thor"

module Codelation
  class Cli < Thor
    desc "development:install", "Install the development tools used by Codelation"
    def development_install
      print_heading("Installing Dependencies")
      install_dependencies

      print_heading("Installing Atom.app")
      install_atom

      print_heading("Installing Atom Packages")
      install_atom_packages

      print_heading("Installing Dot Files")
      install_dot_files

      print_heading("Installing Postgres.app")
      install_postgres

      print_heading("Installing Ruby")
      install_ruby

      print_heading("Installing Sequel Pro.app")
      install_sequel_pro

      `source ~/.bash_profile`
    end
  end
end
