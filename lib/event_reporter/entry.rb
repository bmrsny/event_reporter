module EventReporter
  class Entry
    attr_reader :reg_date,
                :first_name,
                :last_name,
                :email,
                :phone,
                :street,
                :city,
                :state,
                :zipcode

    def initialize(data)
      @reg_date   = data[:regdate]
      @first_name = name_cleaner(data[:first_name])
      @last_name  = name_cleaner(data[:last_name])
      @email      = data[:email_address]
      @phone      = phone_cleaner(data[:homephone])
      @street     = street_cleaner(data[:street])
      @city       = city_cleaner(data[:city])
      @state      = state_cleaner(data[:state])
      @zipcode    = zipcode_cleaner(data[:zipcode])
    end

    def name_cleaner(name)
      name.split(" ").map(&:capitalize).join(' ')
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
      street.to_s.empty? ? "No address provided" : street
    end

    def city_cleaner(city)
      city.to_s.empty? ? "No city provided" : city
    end

    def state_cleaner(state)
      state.to_s.empty? ? "No state provided" : state
    end

  end
end
