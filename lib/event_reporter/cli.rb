module EventReporter
  class CLI
    attr_accessor :command, :instream, :outstream

    def initialize(instream, outstream)
      @instream = instream
      @outstream = outstream
      @command = ''
    end

    def call
      until quit?
        get_input
        process_command
      end
    end

    def process_command
      case
      when load?
      when find?
      when queue?
      when help?
      when quit?
      else
        puts "Invalid Command"
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
      self.command = instream.gets
                             .strip
                             .downcase
                             .split(" ")[0]
    end
  end
end
