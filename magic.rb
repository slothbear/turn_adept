$me = 'SCOTTY|WAROMAT'
$players = ['SCOTTY', 'WAROMAT']
$worldCount = 0
$ordable = Array.new

def newWorld
  $ordable.each {|order| puts "//  #{order}"}
  puts
  $ordable.clear
end


begin
  # read file line by line
  # recognize start of turn, end of turn,
  # ======================================
  # collect Orderables:
  # my fleets
  # my artifacts
  # my defense or resources or ?
  # at next world or end of turn, spit orderables.

  myWorld = false
  myShip = false
  worldNum = ""
    
  IO.foreach("scotomat6.txt") do |line|
  #         S36<SCOTTY>[1:7],Moved
  
    if line =~ /^World (\d+) <(\w+)>/
      newWorld
      worldNum = $1
      myWorld = $players.index($2) != nil
      puts "World #{worldNum} <#{$2}>"
    end
    
    # my ships are always mine
    
    if line =~ /S(\d+)<(#$me)>\[/
      $ordable << line
      myShip = $players.index($2) != nil
    end

    # need to distinguish between world and fleet, plus this only gets 1/line.
    $ordable << "#{$2} A#{$1}" if line =~ /.*A(\d+):(\w+ \w+)/ and myShip
    
    # only order tech and defenses at my worlds.
    next unless myWorld
    $ordable << "W#{worldNum}B#{$1}" if line =~ /.*Resources\[(\d+)\]/
    $ordable << "D#{worldNum}T#{$1}" if line =~ /.*Defense\[(\d+)\]/ and $1.to_i > 1


  end
  
end

