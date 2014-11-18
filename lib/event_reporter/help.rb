module EventReporter
  class Help
    attr_reader :printer,
                :criteria
    def initialize(instream, outstream, printer, criteria)
      @instream  = instream
      @outstream = outstream
      @printer   = printer
      @criteria  = criteria
    end
    @@valid_commands = [ "", "queue count", "queue clear", "queue print", "queue print by", "queue save to", "find", "load"]

    def call
      return printer.invalid_help_queue_command(criteria.join(" ")) if !valid_criteria?
      process_command
    end

    def process_command
       case
       when help?            then puts "Help instructions"
       when queue_count?     then puts "queue counted"#print_queue_count_help
       when queue_clear?     then printer.print_queue_clear_help(criteria[0..-1].join(" "))
       when queue_print?     then puts "queue printed"#print_queue_print_help
       when queue_print_by?  then puts "Printed By Message"
       when queue_save_to?   then puts "SAVED TOOOOO"
       end

    end

    def valid_criteria?
      valid_length? && valid_commands?
    end

    def valid_length?
      criteria.length.between?(0, 3)
    end

    def valid_commands?
      @@valid_commands.include?(criteria[0..-1].join(" "))
    end

    def queue_count?
      criteria[0..-1].join(" ") == 'queue count'
    end

    def queue_clear?
      criteria[0..-1].join(" ") == 'queue clear'
    end

    def queue_print?
      criteria[0..-1].join(" ") == 'queue print'
    end

    def queue_print_by?
      criteria[0..-1].join(" ") == 'queue print by'
    end

    def queue_save_to?
      criteria[0..-1].join(" ") == 'queue save to'
    end

    def help?
      criteria[0] == nil
    end
  end
end
