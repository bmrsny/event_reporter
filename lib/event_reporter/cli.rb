module EventReporter
  class CLI
    def initialize(instream, outstream)
      @instream = instream
      @outstream = outstream
      @command = ''
    end
    def call
      until quit?
        get_input
      end
    end

    def quit?
      @command == 'q' || @command == 'quit'
    end

    def get_input
      @command = @instream.gets.strip.downcase
    end
  end
end
