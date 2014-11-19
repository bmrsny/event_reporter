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

    def find_and_index
      criteria.include?("and") ? criteria.index("and") : 0
    end

    def valid_attribute?
      valid_attributes = EventReporter::Entry.instance_methods(false).grep(/^((?!cleaner).)*$/)
      if criteria.include?("and")
        valid_attributes.include?(criteria[0].to_sym) && valid_attributes.include?(criteria[find_and_index + 1].to_sym)
      else
        valid_attributes.include?(criteria[0].to_sym)
      end
    end

    def find_entries
      first_criteria = criteria[1..(find_and_index - 1)].join(" ")
      second_criteria = criteria[(find_and_index + 2)..-1].join(" ") if criteria.include?("and")
      found = get_matching_entries(first_criteria, second_criteria)
      print_found(found.length)
      populate_queue(found)
    end

    def get_matching_entries(first_criteria, second_criteria)
      $entry_repository.entries.select do |entry|
        if criteria.include?("and")
          entry.send(criteria[0].to_sym).downcase == first_criteria &&
          entry.send(criteria[find_and_index + 1]).downcase == second_criteria
        else
          entry.send(criteria[0].to_sym).downcase == first_criteria
        end
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
