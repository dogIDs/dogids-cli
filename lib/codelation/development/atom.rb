require "open-uri"
require "open_uri_redirections"
require "progressbar"
require_relative "../../progress_bar"
require "thor"

module Codelation
  class Cli < Thor
    ATOM_APP_DOWNLOAD_URL = "https://atom.io/download/mac"

  private

    # Install Atom.app
    def install_atom
      zip_file_path = download_file(ATOM_APP_DOWNLOAD_URL)
      extract_app_from_zip("Atom.app", zip_file_path)
    end
  end
end
