module EventReporter
  class Printer
    attr_reader :outstream

    def initialize(outstream)
      @outstream = outstream
    end

    def invalid_command
      outstream.puts "Invalid Command"
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
      outstream.puts "Invalid load criteria: you entered #{criteria_length} criterion, should have been 1 or 0."
    end

    def invalid_file_name(file_name)
      outstream.puts "'#{file_name}' does not exist in the projects 'files' directory"
    end

    def confirm_file_load(entries_loaded)
      outstream.puts ">>> Load Complete: #{entries_loaded} entries added to the Entry Repository"
    end
  end
end
