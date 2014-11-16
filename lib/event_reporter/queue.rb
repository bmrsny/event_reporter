module EventReporter
  class Queue
    attr_reader :criteria

    def initialize(instream, outstream, printer, criteria)
      @instream   = instream
      @outstream  = outstream
      @printer    = printer
      @criteria   = criteria
    end

    @@valid_commands = ["count", "clear", "print", "print by", "save to"]

    def call
      #return printer.invalid_queue_call if !valid_criteria?
      valid_criteria?
      #check if valid
      #process command
    end

    def process_command
    end

    def valid_criteria?
      if criteria.length == 1 && @@valid_commands.include?(criteria[0])
        puts "single criteria"
      elsif criteria.length == 3 && @@valid_commands.include?(criteria[0..1].join(" "))
        puts "multi criteria"
      else
        puts "no"
      end
    end
  end
end
