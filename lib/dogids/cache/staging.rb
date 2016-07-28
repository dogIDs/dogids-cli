require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def cache_staging(vm_name = nil, cache = nil)
        ssh_address = get_config_url("staging",vm_name)
        return if ssh_address == false
        case cache
        when "category"
          print_heading("Checking the category reviews cache")
          Net::SSH.start("#{ssh_address}", "dogids") do |ssh|
            ssh.exec!(count_category_cache_files_staging_command) do |_channel, _stream, data|
              print_command("Current category reviews: " + data)
            end
            if yes?("-----> Continue with clearing the STAGING category item cache? [no]")
              print_heading("Clearing the staging category cache")
              ssh.exec!(clear_category_cache_staging_command) do |_channel, _stream, data|
              end
            end
          end
        when "clear"
          print_heading("Let's start clearing the entire staging cache")
          cache_staging(vm_name,"category")
          cache_staging(vm_name,"qa")
          cache_staging(vm_name,"javascript")
          cache_staging(vm_name,"css")
        when "css"
          print_heading("Checking the CSS cache")
          Net::SSH.start("#{ssh_address}", "dogids") do |ssh|
            ssh.exec!(count_css_cache_files_staging_command) do |_channel, _stream, data|
              print_command("Current CSS cache files: " + data)
            end
            if yes?("-----> Continue with clearing the STAGING CSS cache? [no]")
              print_heading("Clearing the development CSS cache")
              ssh.exec!(clear_css_cache_staging_command) do |_channel, _stream, data|
              end
            end
          end
        when "javascript"
          print_heading("Checking the Javascript cache")
          Net::SSH.start("#{ssh_address}", "dogids") do |ssh|
            ssh.exec!(count_javascript_cache_files_staging_command) do |_channel, _stream, data|
              print_command("Current Javascript cache files: " + data)
            end
            if yes?("-----> Continue with clearing the STAGING Javascript cache? [no]")
              print_heading("Clearing the development Javascript cache")
              ssh.exec!(clear_javascript_cache_staging_command) do |_channel, _stream, data|
              end
            end
          end
        when "qa"
          print_heading("Checking the product Q&A cache")
          Net::SSH.start("#{ssh_address}", "dogids") do |ssh|
            ssh.exec!(count_qa_cache_files_staging_command) do |_channel, _stream, data|
              print_command("Current category reviews: " + data)
            end
            if yes?("-----> Continue with clearing the STAGING product Q&A cache? [no]")
              print_heading("Clearing the staging QA cache")
              ssh.exec!(clear_qa_cache_staging_command) do |_channel, _stream, data|
              end
            end
          end
        else
          cache
        end
      end

      private

      def count_category_cache_files_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "find . -iname 'category*' | wc -l"
        commands.join("&& ")
      end

      def count_qa_cache_files_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "find . -iname 'turnto*' | wc -l"
        commands.join("&& ")
      end

      def count_javascript_cache_files_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/temp/resource_cache"
        commands << "find . -iname '*.javascript.gz' | wc -l"
        commands.join("&& ")
      end

      def count_css_cache_files_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/temp/resource_cache"
        commands << "find . -iname '*.css.gz' | wc -l"
        commands.join("&& ")
      end

      def clear_category_cache_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "sudo find . -type f -iname 'category*' -delete"
        commands.join("&&")
      end

      def clear_qa_cache_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "sudo find . -type f -iname 'turnto*' -delete"
        commands.join("&&")
      end

      def clear_css_cache_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/temp/resource_cache"
        commands << "sudo find . -type f -iname '*.css.gz' -delete"
        commands.join("&&")
      end

      def clear_javascript_cache_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/temp/resource_cache"
        commands << "sudo find . -type f -iname '*.javascript.gz' -delete"
        commands.join("&&")
      end
    end
  end
end
