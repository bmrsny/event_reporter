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
      new_entry = $entry_repository.entries.select do |entry|
        entry.instance_variable_get("@#{criteria[0]}") == criteria[1].to_s
      end
      puts new_entry
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
