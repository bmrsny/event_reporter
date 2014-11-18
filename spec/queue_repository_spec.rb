require 'spec_helper'

RSpec.describe EventReporter::QueueRepository do
  it 'creates new entry objects when given an array of objects' do
    data = {:_=>"99", :regdate=>"12/8/08 21:24", :first_name=>"Maia", :last_name=>"Allen", :email_address=>"gqckerj@jumpstartlab.com", :homephone=>"(913) 963-7000", :street=>"1541 Kentucky St.", :city=>"Lawrence", :state=>"KS", :zipcode=>"66044"}
    entry = EventReporter::Entry.new(data)
    entry_objects = [entry, entry]
    queue_repo = EventReporter::QueueRepository.new(entry_objects)
    expect(queue_repo.entries.length).to eql(2)
    expect(queue_repo.entries[0]).to be_a EventReporter::Entry
  end
end
