require "thor"

module Codelation
  class Cli < Thor
  private

    # Install dot files and load them into ~/.bash_profile
    def install_dot_files
      # Create the directory ~/.codelation/bash if it doesn't exist
      FileUtils.mkdir_p(File.expand_path("~/.codelation/bash"))

      # Copy dot files to ~/.codelation
      copy_file "dot_files/.codelation.bash",     "~/.codelation/bash/.codelation.bash"
      copy_file "dot_files/.git-completion.bash", "~/.codelation/bash/.git-completion.bash"
      copy_file "dot_files/.git-prompt.sh",       "~/.codelation/bash/.git-prompt.sh"
      copy_file "dot_files/.jshintrc",            "~/.jshintrc"
      copy_file "dot_files/.rubocop.yml",         "~/.rubocop.yml"
      copy_file "dot_files/.scss-lint.yml",       "~/.scss-lint.yml"

      # Add `source ~/.codelation.bash` to ~/.bash_profile if it doesn't exist
      append_to_file "~/.bash_profile", "source ~/.codelation/bash/.codelation.bash"
    end
  end
end
