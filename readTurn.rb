require "rexml/document"
require "rexml/streamlistener"
include REXML  # so that we don't have to prefix everything with REXML::...

class Handler
    include REXML::StreamListener

  def tag_start(name,attrs)
    puts "<" + name + ">"
    attrs.each_pair do |key, value|
      puts "   " + key + "=" + value unless key == "displayname"
    end
  end

  def text( text)
    if text.strip != ""
      puts "      " + text
      end
  end
  
end # Handler

begin
  file = File.new( "SCORPION_T3.xml" )
  doc = Document.new file
  puts "go"

#  doc.elements.each("TURNSHEET/WORLDS/WORLD/NUMBER") { |element|
#    puts element.text # attributes["displayname"]
#    }

puts "phase II"

Document.parse_stream((File.new "SCORPION_T3.xml"), Handler.new)

puts "fin"

end