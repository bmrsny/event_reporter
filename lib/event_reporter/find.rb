module EventReporter
  class Find
    attr_accessor :criteria
    attr_reader :printer

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
      $entry_repository.nil? ? print_found(0) : find_entries
    end

    def valid_criteria?
      criteria.length >= 2
    end

    def valid_attribute?
      valid_attributes = EventReporter::Entry.instance_methods(false).grep(/^((?!cleaner).)*$/)
      valid_attributes.include?(criteria[0].to_sym)
    end

    def find_entries
      search_criteria = criteria[1..-1].join(" ")
      found = get_matching_entries(search_criteria)
      print_found(found.length)
      populate_queue(found)
    end

    def get_matching_entries(search_criteria)
      $entry_repository.entries.select do |entry|
        entry.send(criteria[0].to_sym).downcase == search_criteria
      end
    end

    def print_found(num)
      printer.print_number_found(num)
    end

    def populate_queue(found)
      $queue_repository = EventReporter::QueueRepository.new(found)
    end
  end
end
