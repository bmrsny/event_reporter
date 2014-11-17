module EventReporter
  class QueueRepository
    attr_reader :entries

    def initialize(entries)
      @entries = entries
    end

  end
end
