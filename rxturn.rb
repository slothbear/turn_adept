require "rexml/parsers/pullparser"

parser = REXML::Parsers::PullParser.new(IO.read("scotomat1.xml"))

xml = ""

while parser.has_next?
  pull_event = parser.pull
  puts(pull_event[0]) if pull_event.start_element?
end