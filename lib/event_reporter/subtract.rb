module EventReporter
  class Subtract < Find
    attr_accessor :criteria
    attr_reader :printer

    def initialize(instream, outstream, printer, criteria)
      @instream   = instream
      @outstream  = outstream
      @printer    = printer
      @criteria   = criteria
    end

    def call
      return printer.no_queue_to_subtract_from if no_queue?
      return printer.invalid_find_command(criteria.join(" ")) if !valid_criteria?
      return printer.invalid_find_attribute(criteria[0]) if !valid_attribute?
      remove_valid_entries
    end

    def no_queue?
      $queue_repository.nil?
    end

    def remove_valid_entries
      first_criteria = criteria[1..(find_and_index - 1)].join(" ")
      second_criteria = criteria[(find_and_index + 2)..-1].join(" ") if criteria.include?("and")
      new_queue = remove_entries(first_criteria, second_criteria)
      num_removed = $queue_repository.entries.length - new_queue.length
      print_removed(num_removed)
      populate_queue(new_queue)
    end

    def remove_entries(first_criteria, second_criteria)
      $queue_repository.entries.reject do |entry|
        if criteria.include?("and")
          entry.send(criteria[0].to_sym).downcase == first_criteria &&
          entry.send(criteria[find_and_index + 1]).downcase == second_criteria
        else
          entry.send(criteria[0].to_sym).downcase == first_criteria
        end
      end
    end

    def print_removed(num)
      printer.print_number_removed(num)
    end

    def populate_queue(new_queue)
      $queue_repository = EventReporter::QueueRepository.new(new_queue)
    end
  end
end
