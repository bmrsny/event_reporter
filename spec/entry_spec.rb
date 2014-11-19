require 'spec_helper'

RSpec.describe EventReporter::Entry do
  it 'creates a new entry object when given a valid hash' do
    data = {:_=>"99", :regdate=>"12/8/08 21:24", :first_name=>"Maia", :last_name=>"Allen", :email_address=>"gqckerj@jumpstartlab.com", :homephone=>"(913) 963-7000", :street=>"1541 Kentucky St.", :city=>"Lawrence", :state=>"KS", :zipcode=>"66044"}
    entry = EventReporter::Entry.new(data)
    expect(entry).to be_a EventReporter::Entry
  end

  context 'when loading names' do
    before do
      data = {:_=>"99", :regdate=>"12/8/08 21:24", :first_name=>"Maia", :last_name=>"Allen", :email_address=>"gqckerj@jumpstartlab.com", :homephone=>"(913) 963-7000", :street=>"1541 Kentucky St.", :city=>"Lawrence", :state=>"KS", :zipcode=>"66044"}
      @entry = EventReporter::Entry.new(data)
    end
    it 'makes the first letter capitalized' do
      name = "will"
      expect(@entry.name_cleaner(name)).to eq("Will")
    end

    it 'capitalizes a double first name' do
      name = "tannis ruth"
      expect(@entry.name_cleaner(name)).to eq("Tannis Ruth")
    end
  end

  context 'when loading zipcodes' do
    before do
      data = {:_=>"99", :regdate=>"12/8/08 21:24", :first_name=>"Maia", :last_name=>"Allen", :email_address=>"gqckerj@jumpstartlab.com", :homephone=>"(913) 963-7000", :street=>"1541 Kentucky St.", :city=>"Lawrence", :state=>"KS", :zipcode=>"66044"}
      @entry = EventReporter::Entry.new(data)
    end
    it 'replaces empty zipcode with 0\'s' do
      zipcode = ""
      expect(@entry.zipcode_cleaner(zipcode)).to eq("00000")
    end

    it 'takes a zipcode shorter than 5 numbers and makes it 5 numbers and adds leading zeros' do
      zipcode = "8000"
      expect(@entry.zipcode_cleaner(zipcode)).to eq("08000")
    end
    it 'takes a zipcode longer than 5 and makes it a 5 number zipcode' do
      zipcode = "800001"
      expect(@entry.zipcode_cleaner(zipcode)).to eq("80000")
    end
  end

  context 'when loading phone numbers' do
    before do
      data = {:_=>"99", :regdate=>"12/8/08 21:24", :first_name=>"Maia", :last_name=>"Allen", :email_address=>"gqckerj@jumpstartlab.com", :homephone=>"(913) 963-7000", :street=>"1541 Kentucky St.", :city=>"Lawrence", :state=>"KS", :zipcode=>"66044"}
      @entry = EventReporter::Entry.new(data)
    end
    it 'returns invalid if phone number is not 10 digits' do
      phone = "###-#33-3564"
      expect(@entry.phone_cleaner(phone)).to eq("Not Provided")
    end

    it 'removes non digit characters from phone number' do
      phone = "#3035446554"
      expect(@entry.phone_cleaner(phone)).to eq("3035446554")
    end
    it 'removes invalid characters and formats phone number' do
      phone = "(303) 544-9222"
      expect(@entry.phone_cleaner(phone)).to eq("3035449222")
    end
    it 'removes invalid characters and formats phone number when 11 digits' do
      phone = "1.303.544-9222"
      expect(@entry.phone_cleaner(phone)).to eq("13035449222")
    end
  end

  context 'when checking for an empty attribute' do
    before do
      data = {:_=>"99", :regdate=>"12/8/08 21:24", :first_name=>"Maia", :last_name=>"Allen", :email_address=>"gqckerj@jumpstartlab.com", :homephone=>"(913) 963-7000", :street=> nil, :city=>"", :state=>"KS", :zipcode=>"66044"}
      @entry = EventReporter::Entry.new(data)
    end
    it 'returns a not provided message when street is nil' do
      expect(@entry.street).to eq("No address provided")
    end

    it 'returns a not provided message when city is blank' do
      expect(@entry.city).to eq("No city provided")
    end

    it 'acuaratley returns the state when provided' do
      expect(@entry.state).to eq("KS")
    end
  end
end
