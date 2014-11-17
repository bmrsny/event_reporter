module EventReporter
  class Find
    attr_reader :criteria,
                :printer

    def initialize(instream, outstream, printer, criteria)
      @instream   = instream
      @outstream  = outstream
      @printer    = printer
      @criteria   = criteria
    end

    def call
      return printer.invalid_find_command(criteria.join(" ")) if !valid_criteria?
      return printer.invalid_find_attribute(criteria[0]) if !valid_attribute?
      find_valid_entries
    end

    def find_valid_entries
      if $queue_repository.nil?
        printer.print_number_found(0)
      else
        found = $entry_repository.entries.select do |entry|
          entry.send(criteria[0].to_sym).downcase == criteria[1]
        end
        printer.print_number_found(found.length)
        $queue_repository = EventReporter::QueueRepository.new(found)
      end
    end

    def valid_criteria?
      criteria.length == 2
    end

    def valid_attribute?
      valid_attributes = EventReporter::Entry.instance_methods(false).grep(/^((?!cleaner).)*$/)
      valid_attributes.include?(criteria[0].to_sym)
    end
  end
end
