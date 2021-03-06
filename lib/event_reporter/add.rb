module EventReporter
  class Add < Find
    attr_accessor :criteria
    attr_reader :printer

    def initialize(instream, outstream, printer, criteria)
      @instream   = instream
      @outstream  = outstream
      @printer    = printer
      @criteria   = criteria
    end

    def call
      return printer.no_queue_to_add_to if no_queue?
      return printer.invalid_find_command(criteria.join(" ")) if !valid_criteria?
      return printer.invalid_find_attribute(criteria[0]) if !valid_attribute?
      find_valid_entries
    end

    def no_queue?
      $queue_repository.nil?
    end

    def populate_queue(found)
      $queue_repository.entries.push(*found)
    end
  end
end
