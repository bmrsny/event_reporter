module EventReporter
  class Printer
    attr_reader :outstream

    def initialize(outstream)
      @outstream = outstream
    end

    def invalid_command
      outstream.puts ">>> Invalid Command"
    end

    def intro_message
      outstream.puts "Welcome to Event Reporter"
    end

    def command_prompt
      outstream.print "Enter Command: "
    end

    def outro_message
      outstream.puts "Goodbye"
    end

    def invalid_load_criteria(criteria_length)
      outstream.puts ">>> Invalid load criteria: you entered #{criteria_length} criterion, should have been 1 or 0."
    end

    def invalid_file_name(file_name)
      outstream.puts ">>> '#{file_name}' does not exist in the projects 'files' directory"
    end

    def confirm_file_load(entry_repo_size)
      outstream.puts ">>> Load Complete: #{entry_repo_size} entries in the entry repository"
    end

    def invalid_queue_command(criteria)
      outstream.puts ">>> Invalid queue criteria: You entered 'queue #{criteria}' which is not valid command"
      outstream.puts ">>> For help, type 'help queue'"
    end

    def invalid_find_command(criteria)
      outstream.puts ">>> Invalid find criteria: You entered 'find #{criteria}' which is not valid command"
      outstream.puts ">>> For help, type 'help find'"
    end

    def invalid_find_attribute(attribute)
      outstream.puts ">>> Invalid attribute: '#{attribute}' is not a valid search attribute"
    end

    def print_number_found(number)
      outstream.puts ">>> #{number} records added to queue"
    end

    def print_queue_count(records)
      outstream.puts ">>> #{records} records in queue"
    end

    def print_queue_cleared(records)
      outstream.puts ">>> Queue now has #{records} records"
    end

    def print_queue_headers
      outstream.puts "LAST NAME\t\tFIRST NAME\t\tEMAIL\t\tZIPCODE\t\tCITY\t\tSTATE\t\tADDRESS\t\t\PHONE"
    end

    def print_queue_row(entry)
      outstream.puts "#{entry.last_name}\t#{entry.first_name}\t#{entry.email}\t#{entry.zipcode}\t#{entry.city}\t#{entry.state}\t#{entry.street}\t#{entry.phone}"
    end

    def print_nothing_to_print
      outstream.puts ">>> Nothing to print"
    end

    def confirm_file_saved(file_name)
      outstream.puts ">>> '#{file_name}' saved to '/files' directory"
    end

    def confirm_file_overwrite(file_name)
      outstream.puts ">>> '#{file_name}' already exists in '/files' directory"
      outstream.puts ">>> Do you want to overwrite this file?"
    end

    def confirm_overwrite_prompt
      outstream.print ">>> ENTER 'Y' to confirm: "
    end

    def file_not_overwritten
      outstream.puts ">>> File not overwritten"
    end
  end
end
