module EventReporter
  class EntryRepository
    attr_reader :entries

    def initialize(entries)
      @entries = entries.map {|entry| Entry.new(entry)}
    end

  end
end
