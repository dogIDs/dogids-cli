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
      print_command("Downloading from: #{ATOM_APP_DOWNLOAD_URL}")
      download_atom
      write_atom_zip
      extract_atom_zip
    end

    # Download Atom.app from https://atom.io
    def download_atom
      progress_bar = nil
      @atom_uri = open(ATOM_APP_DOWNLOAD_URL,
        allow_redirections: :all,
        content_length_proc: -> (content_length) {
          if content_length && content_length > 0
            progress_bar = ProgressBar.new("       ", content_length)
            progress_bar.file_transfer_mode
          end
        },
        progress_proc: -> (size) {
          progress_bar.set(size) if progress_bar
        }
      )
      puts "" # Needed to avoid progress bar weirdness
    end

    # Save the downloaded file for Atom.app
    # to resources/temp/atom.zip
    def write_atom_zip
      @atom_zip_file_path = File.join(Cli.source_root, "temp", "atom.zip")
      open(@atom_zip_file_path, "wb") do |file|
        file.write(@atom_uri.read)
      end
    end

    # Extract the zip file to /Applications and delete the temp file
    def extract_atom_zip
      print_command("Extracting Atom.app to /Applications")

      # Delete existing Atom.app
      FileUtils.rm_rf("/Applications/Atom.app") if Dir.exist?("/Applications/Atom.app")

      # Unzip temporary file to /Applications/Atom.app
      `unzip #{@atom_zip_file_path} -d /Applications`

      # Delete zip file
      File.delete(@atom_zip_file_path)
    end
  end
end
