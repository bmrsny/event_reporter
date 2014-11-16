require 'spec_helper'

RSpec.describe EventReporter::EntryRepository do
  it 'creates new entry objects when given an array of valid hashes' do
    rows = [{:_=>"99", :regdate=>"12/8/08 21:24", :first_name=>"Maia", :last_name=>"Allen", :email_address=>"gqckerj@jumpstartlab.com", :homephone=>"(913) 963-7000", :street=>"1541 Kentucky St.", :city=>"Lawrence", :state=>"KS", :zipcode=>"66044"},
            {:_=>"100", :regdate=>"12/8/08 21:26", :first_name=>"Genna", :last_name=>"Chudkowski", :email_address=>"xkriffard@jumpstartlab.com", :homephone=>"856-401-2000", :street=>"123 Garfield Ave", :city=>"Blackwood", :state=>"NJ", :zipcode=>"8012"}]
    entry_repo = EventReporter::EntryRepository.new(rows)
    expect(entry_repo.entries.length).to eql(2)
  end
end
