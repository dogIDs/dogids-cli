require "thor"

module Codelation
  class Cli < Thor
  private

    # Install dependencies for building and installing everything else.
    def install_dependencies
      unless `which brew`.length > 1
        print_command("Installing Homebrew from http://brew.sh")
        print_command("Re-run `codelation developer:install after Homebrew has been installed`")
        sleep 3
        exec('ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
      end

      run_command("brew install bash")
      run_command("brew install git")
      run_command("brew install imagemagick")
      run_command("brew install openssl")
      run_command("brew install shellcheck")
      run_command("brew install v8")
      run_command("brew install wget")
    end
  end
end
