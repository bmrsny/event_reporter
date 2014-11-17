module EventReporter
  class Queue
    attr_reader :criteria,
                :printer

    def initialize(instream, outstream, printer, criteria)
      @instream   = instream
      @outstream  = outstream
      @printer    = printer
      @criteria   = criteria
    end

    $valid_commands = ["count", "clear", "print", "print by", "save to"]

    def call
      return printer.invalid_queue_command(criteria.join(" ")) if !valid_criteria?
      process_command
    end

    def process_command
      case
      when count?
        print_queue_count
      when clear?
        puts "cleared"
      when print?
        puts "printed"
      when print_by?
        puts "print by string"
      when save_to?
        puts "saved to"
      end
    end

    def valid_criteria?
      if criteria.length == 1 && $valid_commands.include?(criteria[0]) then true
      elsif criteria.length == 3 && $valid_commands.include?(criteria[0..1].join(" ")) then true
      else false
      end
    end

    def queue_count
      $queue_repository.entries.length
    end

    def print_queue_count
      count = $queue_repository.nil? ? 0 : queue_count
      printer.print_queue_count(count)
    end

    def count?
      criteria[0] == 'count'
    end

    def clear?
      criteria[0] == 'clear'
    end

    def print?
      criteria[0] == 'print' && criteria.length == 1
    end

    def print_by?
      criteria[0..1].join(" ") == 'print by'
    end

    def save_to?
      criteria[0..1].join(" ") == "save to"
    end
  end
end
