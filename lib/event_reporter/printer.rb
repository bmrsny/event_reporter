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
  end
end
