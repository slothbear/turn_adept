$me = 'POLLUX|SCOTTY|WAROMAT|SCORPION|ECLIPSE|ARISTO'
$players = ['POLLUX', 'SCOTTY', 'WAROMAT', 'SCORPION', 'ECLIPSE', 'ARISTO']

#
#World 244 <RAINBOW> [96,230,332,340]
#     Bulk[1],B-Prod[1],Population[64/3m],Defense[1]
#        S36<SCOTTY>[1:7],Moved
#     S105<SUNSHINE>-->W340   
#
#World 246 <?> [15,63,116,364],Lost by <MIMIC>
#     Dunamium[2],D-Prod[1],Population[56]
#        S5<MIMIC>[1:7],Moved
#        S112<SCOTTY>[1:3],Bulk[1],Dunamium[1],Fires at W246
#
#//  S36
#//  S112
#!! S36 belongs to previous world

#World 494 <SCORPION> [153,193,470]
#     Technology[2],Resources[2],Bulk[2],B-Prod[2],Kwillic[3],Defense[6]
#        S404<SCORPION>[1:1]
#
#======================================
# S404 is not flushed on end of turn

#World 417 <ECLIPSE> [410,833]
#     Technology[1],Resources[1],Bulk[20],B-Prod[3],Population[152m],
#     Defense[8]
#
#World 422 <?> [43,90,376,503],Lost by <DOMINION>
#     Bulk[7],B-Prod[4],Population[187/15m,ECLIPSE]
#        S77<DOMINION>[1:2],Moved
#        S115<DOMINION>[1:34],Moved
#        S164<DOMINION>[1:30],Moved
#        S210<FUNGUS>[1:3],Fires at W422
#        S259<DOMINION>[1:3],Moved
#        S400<DOMINION>[1:46],Moved
#     S268<DOMINION>-->W503   S569<DOMINION>-->W503   
#
#//  W417T1
#//  D417T8
# stuff for world 417 shown after next world -- and not the last world!
# lots more worlds after that.


#World 298 <SCORPION> [146,435,447]
#     Technology[1],Resources[1],Bulk[5],B-Prod[2],Kwillic[3],Defense[3]
#
#World 328 <?> [267,329,458],Lost by <PSYCHE>,Bombed
#     Population[0,Deaths=119/21m]
#        S264<SCORPION>[1:40],Bulk[6],Dropped Bomb
#
#//  W298T1
#//  D298T3
#//  S264

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
    
  IO.foreach("scotomat6.txt") do | line |
  #         S36<SCOTTY>[1:7],Moved
  
    next if line[0] == "#"
    
    if line =~ /======================================/
        newWorld
    end

    if line =~ /^World (\d+) <([^>]+)>/ || line =~ /^W(\d+).*?\[(\w+)/
      newWorld
      worldNum = $1
      myWorld = $players.index($2) != nil
      # puts "World #{worldNum} <#{$2}>"
    end
    
    # my ships are always mine
    if line =~ /S(\d+)<(#$me)>\[/ || line =~ /(\w\d+)\[(ARISTO)\]=/
      $ordable << $1
      myShip = $players.index($2) != nil
    end

    puts line

    # need to distinguish between world and fleet, plus this only gets 1/line.
#    $ordable << "#{$2} A#{$1}" if line =~ /.*A(\d+):(\w+ \w+)/ and myShip
    
    # only order tech and defenses at my worlds.
    next unless myWorld
    $ordable << "W#{worldNum}T#{$1}" if line =~ /.*Resources\[(\d+)\]/
    $ordable << "D#{worldNum}T#{$1}" if line =~ /.*Defense\[(\d+)\]/ and $1.to_i > 1
  end
  
  newWorld
end

