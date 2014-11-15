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
  end
end
