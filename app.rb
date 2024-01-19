require 'ruby2d'
require 'json'
require_relative 'player'
require 'logger'

set title: "Mario"

$tile_size=64
$window_width=$tile_size*24

set width: $window_width

$window_height=$tile_size*13
set height: $window_height

$logger = Logger.new($stdout)

$points=0
$left_lives=2
$level=2
$levels = JSON.parse(File.read('./game_config/levels.json'))
$level_map = $levels["#{$level}"]["map"]
$lose=false

$tileset = Tileset.new(
  'assets/spritesheet_game.png',
  tile_width: 16,
  tile_height: 16,
  scale: 4
)

$tileset.define_tile('coin', 10, 0)
$tileset.define_tile('sky', 0, 0)
$tileset.define_tile('floor', 6, 3)
$tileset.define_tile('floor_2',4,1)

tiles_mapping={"0"=>"sky","15"=>"floor_2","39"=>"floor"}
static_tiles={}

for column in 0..(24)
    for row in 0..(12)
            tile_id=$level_map[row][column].to_s
            if static_tiles[tiles_mapping[tile_id]] == nil then
                static_tiles[tiles_mapping[tile_id]] = []
            end
            static_tiles[tiles_mapping[tile_id]].append({x: column*$tile_size, y: row*$tile_size})
    end
end

$tileset.set_tile('floor', static_tiles["floor"])
$tileset.set_tile('floor_2', static_tiles["floor_2"])
$tileset.set_tile('sky', static_tiles["sky"])



$player = Player.new(0,1)


on :key_held do |event|
    $player.change_move(event)
  end

on :key_up do |event|
    $player.stayInPlace(event)
end

def points_message
    Text.new("Left lives: #{$left_lives}", x:$window_width/2, y:0,size: 40)
end

def level_message
    Text.new("Level: #{$level}", x:$window_width/3, y:0,size: 40)
end

def game_over_message
    Text.new("GAME OVER!", x:$window_width/3, y:$window_height/3,size: 80)
end

curr_points_message=points_message
curr_level_message=level_message

t = Time.now

  update do
    
    dt = Time.now - t
    $player.move(dt)
    t = Time.now
    if $player.died then
        $player = Player.new(0,1)
        curr_points_message.remove
        $left_lives-=1
        if $left_lives < 0 then
            $lose=true
        end
        curr_points_message=points_message
    end

    if $player.win then
        curr_level_message.remove
        $level+=1
        curr_level_message=level_message
    end
    
    if $lose then
        curr_points_message.remove
        curr_level_message.remove
        game_over_message
    end
  end




show