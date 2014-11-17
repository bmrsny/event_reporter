module EventReporter
  class Queue
    attr_reader :criteria,
                :printer,
                :instream

    def initialize(instream, outstream, printer, criteria)
      @instream   = instream
      @outstream  = outstream
      @printer    = printer
      @criteria   = criteria
    end

    $valid_commands = ["count", "clear", "print", "print by", "save to"]

    def call
      return printer.invalid_queue_command(criteria.join(" ")) if !valid_criteria?
      process_command
    end

    def process_command
      case
      when count?
        print_queue_count
      when clear?
        queue_clear
      when print?
        queue_print
      when print_by?
        queue_print_by
      when save_to?
        queue_save_to
      end
    end

    def valid_criteria?
      if criteria.length == 1 && $valid_commands.include?(criteria[0]) then true
      elsif criteria.length == 3 && $valid_commands.include?(criteria[0..1].join(" ")) then true
      else false
      end
    end

    def queue_count
      $queue_repository.nil? ? 0 : $queue_repository.entries.length
    end

    def print_queue_count
      printer.print_queue_count(queue_count)
    end

    def queue_clear
      $queue_repository = nil
      printer.print_queue_cleared(queue_count)
    end

    def queue_print
      if queue_count == 0
        printer.print_nothing_to_print
      else
        printer.print_queue_headers
        $queue_repository.entries.each do |entry|
          printer.print_queue_row(entry)
        end
      end
    end

    def queue_print_by
      queue_sort
      queue_print
    end

    def queue_sort
      if $queue_repository.nil?
        return
      else
        $queue_repository.entries = $queue_repository.entries.sort_by do |entry|
          entry.send(criteria[2].to_sym).downcase
        end
      end
    end

    def queue_save_to
      if file_exists?
        printer.confirm_file_overwrite(criteria[2])
        printer.confirm_overwrite_prompt
        confirmation = instream.gets.strip.downcase
        if confirmation == "y"
          create_csv
          printer.confirm_file_saved(criteria[2])
        else
          printer.file_not_overwritten
        end
      else
        create_csv
        printer.confirm_file_saved(criteria[2])
      end
    end

    def create_csv
      file = generate_file_path
      CSV.open(file, "wb") do |csv|
        csv << ["Last_Name",
                "First_Name",
                "Email_Address",
                "Zipcode",
                "City",
                "State",
                "Address",
                "HomePhone"]

        if $queue_repository.nil?
          return
        else
          $queue_repository.entries.each do |entry|
            csv << ["#{entry.last_name}",
                    "#{entry.first_name}",
                    "#{entry.email}",
                    "#{entry.zipcode}",
                    "#{entry.city}",
                    "#{entry.state}",
                    "#{entry.street}",
                    "#{entry.phone}"]
          end
        end
      end
    end

    def file_exists?
      File.exist?(generate_file_path)
    end

    def generate_file_path
      File.join(EventReporter::LOAD_FILE_DIR, criteria[2])
    end

    def count?
      criteria[0] == 'count'
    end

    def clear?
      criteria[0] == 'clear'
    end

    def print?
      criteria[0] == 'print' && criteria.length == 1
    end

    def print_by?
      criteria[0..1].join(" ") == 'print by'
    end

    def save_to?
      criteria[0..1].join(" ") == "save to"
    end
  end
end
