module EventReporter
  class CLI
    attr_reader :printer
    attr_accessor :command, :instream, :outstream, :criteria

    def initialize(instream, outstream)
      @instream  = instream
      @outstream = outstream
      @command   = ''
      @criteria  = []
      @printer   = EventReporter::Printer.new(outstream)
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
        EventReporter::Load.new(instream, outstream, printer, criteria).call
      when find?
      when queue?
        EventReporter::Queue.new(instream, outstream, printer, criteria).call
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
      input = instream.gets.strip.downcase.split(" ")
      self.command  = get_cli_command(input)
      self.criteria = get_criteria(input)
    end

    def get_cli_command(input)
      input[0]
    end

    def get_criteria(input)
      input[1..-1]
    end
  end
end
