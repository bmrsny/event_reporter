module EventReporter
  class Entry
    attr_reader :first_name

    def initialize(data)
      @id = data[:_]
      @reg_date = data[:regdate]
      @first_name = name_cleaner(data[:first_name])
      @last_name = name_cleaner(data[:last_name])
      @email = data[:email]
      @phone = data[:homephone]
      @street = data[:street]
      @city = data[:city]
      @state = data[:state]
      @zipcode = data[:zipcode]
    end

    def name_cleaner(name)
      name
    end
  end
end
