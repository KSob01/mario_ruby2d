def create_messages()
    @curr_level_message=Text.new("Level: #{$level}", x:$window_width/3, y:0,size: 40)
    @curr_lives_message=Text.new("Left lives: #{$left_lives}", x:$window_width/2, y:0,size: 40)
    @curr_points_message=Text.new("Points: #{$points} / #{$points_to_win}", x:2*$window_width/3, y:0,size: 40)

end

def game_over_message
    Text.new("GAME OVER!", x:$window_width/3, y:$window_height/3,size: 80)
end

def update_messages()
    @curr_lives_message&.remove
    @curr_points_message&.remove
    @curr_level_message&.remove
    create_messages
end

def move_coins(dt)
    $coinset.clear_tiles
    for i in 0..$coins.size - 1 
        $coins[i].move(dt)
    end

    coins_coord = []
    for i in 0..$coins.size - 1 
        coins_coord.append({x:$coins[i].x, y:$coins[i].y})
    end
    $coinset.set_tile('coin', coins_coord)
end


def move_monsters(dt)
    for i in 0..$monsters.size - 1 
        $monsters[i].move(dt)
    end
end

def new_tile_from_png()
    return Tileset.new(
        'assets/spritesheet_game.png',
        tile_width: 16,
        tile_height: 16,
        scale: 4)
end


def new_level()
    $points=0
    $choose_level = (($level - 1) % ($levels.size) + 1)
    $level_map = $levels["#{$choose_level}"]["map"]
    $lose=false
    static_tiles={}
    tiles_mapping={"0"=>"sky","15"=>"floor_2","39"=>"floor"}
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
    update_messages

    $player = Player.new(0,0)

    monsters_conf = $levels["#{$choose_level}"]["monsters"]
    $monsters=[]
    for i in 0.. monsters_conf.size - 1 
        $monsters.append(Monster.new(monsters_conf[i]["x"] * $tile_size, monsters_conf[i]["y"] * $tile_size, monsters_conf[i]["d"]))
    end

    coins_conf = $levels["#{$choose_level}"]["coins"]
    $coins=[]
    for i in 0.. coins_conf.size - 1 
        $coins.append(Coin.new(coins_conf[i]["x"] * $tile_size, coins_conf[i]["y"] * $tile_size))
    end


    $points_to_win = $coins.size
end

def clear_after_level
    $player.sprite.remove
    $coinset.clear_tiles
    $tileset.clear_tiles
    for i in 0 .. $monsters.size - 1 
        $monsters[i].sprite.remove
    end
end