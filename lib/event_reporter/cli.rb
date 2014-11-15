require 'event_reporter/printer'
module EventReporter
  class CLI
    attr_reader :printer
    attr_accessor :command, :instream, :outstream

    def initialize(instream, outstream)
      @instream = instream
      @outstream = outstream
      @command = ''
      @printer = Printer.new(outstream)
    end

    def call
      printer.intro_message
      until quit?
        get_input
        process_command
      end
      printer.outro_message
    end

    def process_command
      case
      when load?
      when find?
      when queue?
      when help?
      when quit?
      else
        printer.invalid_command
      end
    end

    def quit?
      command == 'q' || command == 'quit'
    end

    def load?
      command == 'load'
    end

    def find?
      command == 'find'
    end

    def queue?
      command == 'queue'
    end

    def help?
      command == 'help'
    end

    def get_input
      printer.command_prompt
      self.command = instream.gets
                             .strip
                             .downcase
                             .split(" ")[0]
    end
  end
end
