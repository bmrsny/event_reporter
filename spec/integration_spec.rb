require 'spec_helper'

RSpec.describe EventReporter do
  it "succesfully completes  the 'happy path' spec" do
    instream = StringIO.new("load event_attendees.csv\nqueue count\nfind first_name John\nqueue count\nqueue clear\nqueue count\nhelp\nhelp queue count\nhelp queue print\nq\n")
    outstream = StringIO.new
    EventReporter::CLI.new(instream, outstream).call
    expect(outstream.string).to include("5175 entries")
    outstream.string.slice! "5175 entries"
    expect(outstream.string).to include("0 records in queue")
    outstream.string.slice! "0 records in queue"
    expect(outstream.string).to include("63 records added to queue")
    outstream.string.slice! "63 records added to queue"
    expect(outstream.string).to include("63 records in queue")
    outstream.string.slice! "63 records in queue"
    expect(outstream.string).to include("Queue now has 0 records")
    outstream.string.slice! "Queue now has 0 records"
    expect(outstream.string).to include("0 records in queue")
    outstream.string.slice! "0 records in queue"
    expect(outstream.string).to include(">>> ALL COMMANDS:")
    outstream.string.slice! ">>> ALL COMMANDS:"
    expect(outstream.string).to include(">>> HELP: QUEUE COUNT")
    outstream.string.slice! ">>> HELP: QUEUE COUNT"
    expect(outstream.string).to include(">>> HELP: QUEUE PRINT")
    outstream.string.slice! ">>> HELP: QUEUE PRINT"
  end

  it "succesfully completes  the 'happy path' spec" do
    instream = StringIO.new("load event_attendees.csv\nqueue count\nfind first_name John\nqueue count\nqueue clear\nqueue count\nhelp\nhelp queue count\nhelp queue print\nq\n")
    outstream = StringIO.new
    EventReporter::CLI.new(instream, outstream).call
    expect(outstream.string).to include("5175 entries")
    outstream.string.slice! "5175 entries"
    expect(outstream.string).to include("0 records in queue")
    outstream.string.slice! "0 records in queue"
    expect(outstream.string).to include("63 records added to queue")
    outstream.string.slice! "63 records added to queue"
    expect(outstream.string).to include("63 records in queue")
    outstream.string.slice! "63 records in queue"
    expect(outstream.string).to include("Queue now has 0 records")
    outstream.string.slice! "Queue now has 0 records"
    expect(outstream.string).to include("0 records in queue")
    outstream.string.slice! "0 records in queue"
    expect(outstream.string).to include(">>> ALL COMMANDS:")
    outstream.string.slice! ">>> ALL COMMANDS:"
    expect(outstream.string).to include(">>> HELP: QUEUE COUNT")
    outstream.string.slice! ">>> HELP: QUEUE COUNT"
    expect(outstream.string).to include(">>> HELP: QUEUE PRINT")
    outstream.string.slice! ">>> HELP: QUEUE PRINT"
  end
end
