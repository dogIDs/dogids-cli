require "fileutils"
require "thor"

module Codelation
  class Cli < Thor
    RUBY_INSTALL_VERSION = "0.5.0"
    RUBY_INSTALL_URL = "https://github.com/postmodern/ruby-install/archive/v#{RUBY_INSTALL_VERSION}.tar.gz"
    RUBY_VERSION = "2.2.0"

  private

    # Install Ruby binary and add it to PATH.
    def install_ruby
      return if `~/.codelation/ruby/bin/ruby -v`.include?(RUBY_VERSION)

      # Create the directory ~/.codelation/temp if it doesn't exist
      FileUtils.mkdir_p("~/.codelation/temp")

      print_command("Installing ruby-install")
      install_ruby_install

      print_command("Installing Ruby #{RUBY_VERSION} to ~/.codelation/ruby")
      `ruby-install -i ~/.codelation/ruby ruby #{RUBY_VERSION}`

      print_command("Installing Ruby gems")
      install_gems

      ruby_install_cleanup
    end

    # Install the Ruby gems needed for development.
    def install_gems
      `~/.codelation/ruby/bin/gem install bundler`
      `~/.codelation/ruby/bin/gem install rubocop`
      `~/.codelation/ruby/bin/gem install scss-lint`
    end

    # Install ruby-install from https://github.com/postmodern/ruby-install.
    def install_ruby_install
      @downloaded_file_path = File.join("~/.codelation", "temp", "ruby-install.tar.gz")
      `curl -L -o #{@downloaded_file_path} #{RUBY_INSTALL_URL}`
      `tar -xzvf #{@downloaded_file_path} -C #{File.join("~/.codelation", "temp")}`

      @extracted_path = File.join("~/.codelation", "temp", "ruby-install-#{RUBY_INSTALL_VERSION}")
      `cd #{@extracted_path} && sudo make install`
    end

    # Delete temporary files from installing Ruby.
    def ruby_install_cleanup
      File.delete(@downloaded_file_path)
      FileUtils.rm_rf(@extracted_path) if Dir.exist?(@extracted_path)
    end
  end
end
