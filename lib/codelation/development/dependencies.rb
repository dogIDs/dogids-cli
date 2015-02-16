require "thor"

module Codelation
  class Cli < Thor
  private

    # Install dependencies for building and installing everything else.
    def install_dependencies
      print_command("Installing Homebrew from http://brew.sh")
      `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

      run_command("brew install bash")
      run_command("brew install git")
      run_command("brew install imagemagick")
      run_command("brew install openssl")
      run_command("brew install v8")
      run_command("brew install wget")
    end
  end
end
