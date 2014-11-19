module EventReporter
  class Printer
    attr_reader :outstream

    def initialize(outstream)
      @outstream = outstream
    end

    def invalid_command
      outstream.puts
      outstream.puts ">>> Invalid Command"
      outstream.puts
    end

    def intro_message
      outstream.puts %q{
 ______               _     _____                       _
|  ____|             | |   |  __ \                     | |
| |____   _____ _ __ | |_  | |__) |___ _ __   ___  _ __| |_ ___ _ __
|  __\ \ / / _ \ '_ \| __| |  _  // _ \ '_ \ / _ \| '__| __/ _ \ '__|
| |___\ V /  __/ | | | |_  | | \ \  __/ |_) | (_) | |  | ||  __/ |
|______\_/ \___|_| |_|\__| |_|  \_\___| .__/ \___/|_|   \__\___|_|
                                      | |
                                      |_|}
      outstream.puts
      outstream.puts "Enter 'help' to see available commands"
    end

    def command_prompt
      outstream.print "Enter Command: "
    end

    def outro_message
      outstream.puts "Goodbye"
    end

    def invalid_load_criteria(criteria_length)
      outstream.puts
      outstream.puts ">>> Invalid load criteria: you entered #{criteria_length} criterion, should have been 1 or 0."
      outstream.puts
    end

    def invalid_file_name(file_name)
      outstream.puts
      outstream.puts ">>> '#{file_name}' does not exist in the projects 'files' directory"
      outstream.puts
    end

    def confirm_file_load(entry_repo_size)
      outstream.puts
      outstream.puts ">>> Load Complete: #{entry_repo_size} entries in the entry repository"
      outstream.puts
    end

    def invalid_queue_command(criteria)
      outstream.puts
      outstream.puts ">>> Invalid queue criteria: You entered 'queue #{criteria}' which is not valid command"
      outstream.puts ">>> For help, type 'help queue'"
      outstream.puts
    end

    def invalid_find_command(criteria)
      outstream.puts
      outstream.puts ">>> Invalid find criteria: You entered 'find #{criteria}' which is not valid command"
      outstream.puts ">>> For help, type 'help find'"
      outstream.puts
    end

    def invalid_find_attribute(attribute)
      outstream.puts
      outstream.puts ">>> Invalid attribute: '#{attribute}' is not a valid search attribute"
      outstream.puts
    end

    def print_number_found(number)
      outstream.puts
      outstream.puts ">>> #{number} records added to queue"
      outstream.puts
    end

    def print_queue_count(records)
      outstream.puts
      outstream.puts ">>> #{records} records in queue"
      outstream.puts
    end

    def print_queue_cleared(records)
      outstream.puts
      outstream.puts ">>> Queue now has #{records} records"
      outstream.puts
    end

    def print_nothing_to_print
      outstream.puts
      outstream.puts ">>> Nothing to print"
      outstream.puts
    end

    def confirm_file_saved(file_name)
      outstream.puts
      outstream.puts ">>> '#{file_name}' saved to '/files' directory"
      outstream.puts
    end

    def confirm_file_overwrite(file_name)
      outstream.puts
      outstream.puts ">>> '#{file_name}' already exists in '/files' directory"
      outstream.puts ">>> Do you want to overwrite this file?"
      outstream.puts
    end

    def confirm_overwrite_prompt
      outstream.print ">>> ENTER 'Y' to confirm: "
    end

    def file_not_overwritten
      outstream.puts
      outstream.puts ">>> File not overwritten"
      outstream.puts
    end

    def invalid_help_queue_command(command)
      outstream.puts
      outstream.puts ">>> Invalid help criteria: You entered 'help #{command}' which is not valid command"
      outstream.puts
    end

    def print_help_intro(criteria)
      outstream.puts
      outstream.puts ">>> HELP: #{criteria.upcase}"
      outstream.puts ">>>"
    end

    def print_help_commands
      outstream.puts
      outstream.puts ">>> ALL COMMANDS:"
      outstream.puts ">>>"
    end

    def help
      print_help_commands
      outstream.puts ">>> QUEUE"
      outstream.puts ">>>"
      print_queue_clear_help_content
      print_help_queue_count_content
      print_queue_print_help_content
      queue_print_by_help_content
      queue_save_to_content
      outstream.puts ">>>"
      outstream.puts ">>> LOAD"
      outstream.puts ">>>"
      load_help_content
      outstream.puts ">>>"
      outstream.puts ">>> FIND"
      outstream.puts ">>>"
      load_find_content
      outstream.puts
    end

    def queue_clear_help(criteria)
      print_help_intro(criteria)
      print_queue_clear_help_content
      outstream.puts
    end

    def print_queue_clear_help_content
      outstream.puts ">>> Enter 'queue clear' to clear the queue"
    end

    def queue_count_help(criteria)
      print_help_intro(criteria)
      print_help_queue_count_content
      outstream.puts
    end

    def print_help_queue_count_content
      outstream.puts ">>> Enter 'queue count' to count the queue"
    end

    def queue_print_help(criteria)
      print_help_intro(criteria)
      print_queue_print_help_content
      outstream.puts
    end

    def print_queue_print_help_content
      outstream.puts ">>> Enter 'queue print' to print the queue"
    end

    def queue_print_by_help(criteria)
      print_help_intro(criteria)
      queue_print_by_help_content
      outstream.puts
    end

    def queue_print_by_help_content
      outstream.puts ">>> Enter 'queue print by' to print by attribute"
    end

    def queue_save_to_help(criteria)
      print_help_intro(criteria)
      queue_save_to_content
      outstream.puts
    end

    def queue_save_to_content
      outstream.puts ">>> Enter 'queue save to' to save to a file in the files directory"
    end

    def find_help(criteria)
      print_help_intro(criteria)
      load_find_content
      outstream.puts
    end

    def load_help(criteria)
      print_help_intro(criteria)
      load_help_content
      outstream.puts
    end

    def load_help_content
      outstream.puts ">>> Enter 'load' and a filename from files directory to load file\n"
      outstream.puts ">>> Load with no filename loads the default file event_attendees.csv"
    end

    def load_find_content
      outstream.puts ">>> Enter 'find' to find an attribute"
    end
  end
end
