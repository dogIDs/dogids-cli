require "thor"

module Codelation
  class Cli < Thor
    private
    # Install RVM from http://rvm.io
    def install_rvm
      run_command("\\curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.0")
      run_command("rvm install ruby-2.1.5")
    end
  end
end
