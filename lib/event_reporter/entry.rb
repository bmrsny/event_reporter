module EventReporter
  class Entry
    attr_reader :id,
                :reg_date,
                :first_name,
                :last_name,
                :email,
                :phone,
                :street,
                :city,
                :state,
                :zipcode

    def initialize(data)
      @id         = data[:_]
      @reg_date   = data[:regdate]
      @first_name = name_cleaner(data[:first_name])
      @last_name  = name_cleaner(data[:last_name])
      @email      = data[:email]
      @phone      = phone_cleaner(data[:homephone])
      @street     = street_cleaner(data[:street])
      @city       = city_cleaner(data[:city])
      @state      = state_cleaner(data[:state])
      @zipcode    = zipcode_cleaner(data[:zipcode])
    end

    def name_cleaner(name)
      name
    end

    def zipcode_cleaner(zipcode)
      zipcode.to_s.rjust(5, '0')[0..4]
    end

    def phone_cleaner(phone)
      clean_number = phone.gsub(/[^\d]/,'')
      if clean_number.length == 10 || clean_number.length == 11
        clean_number
      else
        "No valid phone number"
      end
    end

    def street_cleaner(street)
      if street.nil? || street.empty?
        "No street provided"
      else
        street
      end
    end

    def city_cleaner(city)
      if city.nil? || city.empty?
        "No city provided"
      else
        city
      end
    end

    def state_cleaner(state)
      if state.nil? || state.empty?
        "No state provided"
      else
        state
      end
    end
  end
end
