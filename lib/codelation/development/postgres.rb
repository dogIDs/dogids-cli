require "fileutils"
require "open-uri"
require "open_uri_redirections"
require "progressbar"
require_relative "../../progress_bar"
require "thor"
require "zip"

module Codelation
  class Cli < Thor
    POSTGRES_APP_DOWNLOAD_URL = "https://github.com/PostgresApp/PostgresApp/releases/download/9.4.1.0/Postgres-9.4.1.0.zip"

  private

    # Install Postgres.app
    def install_postgres
      print_command("Downloading from: #{POSTGRES_APP_DOWNLOAD_URL}")
      download_postgres
      write_postgres_zip
      extract_postgres_zip
    end

    # Download Postgres.app from http://postgresapp.com
    def download_postgres
      progress_bar = nil
      @postgres_uri = open(POSTGRES_APP_DOWNLOAD_URL,
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

    # Save the downloaded file for Postgres.app
    # to resources/temp/postgres.zip
    def write_postgres_zip
      @postgres_zip_file_path = File.join(Cli.source_root, "temp", "postgres.zip")
      open(@postgres_zip_file_path, "wb") do |file|
        file.write(@postgres_uri.read)
      end
    end

    # Extract the zip file to /Applications and delete the temp file
    def extract_postgres_zip
      print_command("Extracting Postgres.app to /Applications")

      # Delete existing Postgres.app
      FileUtils.rm_rf("/Applications/Postgres.app") if Dir.exist?("/Applications/Postgres.app")

      # Unzip temporary file to /Applications/Postgres.app
      `unzip #{@postgres_zip_file_path} -d /Applications`

      # Delete zip file
      File.delete(@postgres_zip_file_path)
    end
  end
end
