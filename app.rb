require 'ruby2d'
require 'json'
require_relative 'player'
require_relative 'monster'
require_relative 'phisics'
require_relative 'world_management'
require_relative 'coin'
require 'logger'


set title: "Mario"
$tile_size=64
$window_width=$tile_size*24
set width: $window_width
$window_height=$tile_size*13
set height: $window_height
$logger = Logger.new($stdout)

$level=1
$left_lives=2
$levels = JSON.parse(File.read('./game_config/levels.json'))

$tileset = new_tile_from_png()
$coinset = new_tile_from_png()

$coinset.define_tile('coin', 10, 0)
$tileset.define_tile('sky', 0, 0)
$tileset.define_tile('floor', 6, 3)
$tileset.define_tile('floor_2',4,1)


new_level

on :key_held do |event|
    $player.change_move(event)
  end

on :key_up do |event|
    $player.stayInPlace(event)
end



$t = Time.now

  update do

    if $lose then
        $player.sprite.remove
        @curr_points_message.remove
        @curr_level_message.remove
        game_over_message
    else
        update_messages()
        dt = Time.now - $t
        $player.move(dt)
        move_monsters(dt)
        move_coins(dt)

        $t = Time.now
        
        if $player.died then
            $player.sprite.remove
            $player = Player.new(0,1)
            $left_lives-=1
            if $left_lives < 0 then
                $lose=true
            end
        end
    
        if $player.win then
            $level+=1
            clear_after_level
            new_level
        end
    end
  end


show