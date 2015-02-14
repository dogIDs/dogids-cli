require "open-uri"
require "open_uri_redirections"
require "progressbar"
require_relative "../../progress_bar"
require "thor"

module Codelation
  class Cli < Thor
  private

    # Download a file with a progress bar.
    # @param url [String] The url of the file to be downloaded
    # @param file_name [String] The name of the file to be saved
    def download_file(url)
      print_command("Downloading from: #{url}")
      progress_bar = nil
      @download_uri = open(url,
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
      write_downloaded_file(@download_uri)
    end

    # Save the file downloaded with #download_file to resources/temp.
    # @param uri [URI] The URI of the file to be saved
    def write_downloaded_file(uri)
      file_name = File.basename(uri.path)
      @downloaded_file_path = File.join(Cli.source_root, "temp", file_name)
      open(@downloaded_file_path, "wb") do |file|
        file.write(@download_uri.read)
      end
      @downloaded_file_path
    end

    # Extract an app from a zip file to /Applications and delete the zip file.
    # @param app_name [String] The name of the app, including .app
    # @param zip_file_path [String] The full path to the zip file containing the app
    def extract_app_from_zip(app_name, zip_file_path)
      print_command("Extracting #{app_name} to /Applications")

      # Delete existing app
      FileUtils.rm_rf("/Applications/#{app_name}") if Dir.exist?("/Applications/#{app_name}")

      # Unzip temporary file to /Applications
      `unzip #{zip_file_path} -d /Applications`

      # Delete zip file
      File.delete(zip_file_path)
    end
  end
end
