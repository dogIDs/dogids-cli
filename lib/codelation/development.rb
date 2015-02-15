require "thor"

module Codelation
  class Cli < Thor
    desc "development:install", "Install the development tools used by Codelation"
    def development_install
      # print_heading("Installing Atom.app")
      # install_atom
      #
      # print_heading("Installing Atom Packages")
      # install_atom_packages
      #
      # print_heading("Installing Dot Files")
      # install_dot_files
      #
      # print_heading("Installing Postgres.app")
      # install_postgres

      print_heading("Installing Ruby")
      install_ruby

      # print_heading("Installing Sequel Pro.app")
      # install_sequel_pro
      #
      # print_heading("Installing Codelation CLI to PATH")
      # install_codelation_cli
    end
  end
end
