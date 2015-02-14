require "fileutils"
require "open-uri"
require "open_uri_redirections"
require "progressbar"
require_relative "../../progress_bar"
require "thor"
require "zip"

module Codelation
  class Cli < Thor
    SEQUEL_PRO_APP_DOWNLOAD_URL = "http://codelation-cli.s3.amazonaws.com/sequel-pro-1.0.2.zip"

  private

    # Install Sequel Pro.app
    def install_sequel_pro
      zip_file_path = download_file(SEQUEL_PRO_APP_DOWNLOAD_URL)
      extract_app_from_zip("Sequel Pro.app", zip_file_path)
    end
  end
end
