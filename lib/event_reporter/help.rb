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
       when help?            then printer.help
       when queue_count?     then printer.queue_count_help(help_command)
       when queue_clear?     then printer.queue_clear_help(help_command)
       when queue_print?     then printer.queue_print_help(help_command)
       when queue_print_by?  then printer.queue_print_by_help(help_command)
       when queue_save_to?   then printer.queue_save_to_help(help_command)
       when find?            then printer.find_help(help_command)
       when load?            then printer.load_help(help_command)
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

    def help_command
      criteria[0..-1].join(" ")
    end

    def queue_count?
      help_command == 'queue count'
    end

    def queue_clear?
      help_command == 'queue clear'
    end

    def queue_print?
      help_command == 'queue print'
    end

    def queue_print_by?
      help_command == 'queue print by'
    end

    def queue_save_to?
      help_command == 'queue save to'
    end

    def help?
      criteria[0]  == nil
    end

    def find?
      help_command == 'find'
    end

    def load?
      help_command == 'load'
    end
  end
end
