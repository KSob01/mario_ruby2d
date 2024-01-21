class Player
    attr_accessor :sprite, :died, :win
    
    def initialize (x_start,y_start)
        @sprite = Sprite.new(
            'assets/mario_tiles.png',
            x: x_start, 
            y: y_start,
            width: $tile_size,
            height: $tile_size,
            clip_width: 16,
            time: 80,
            animations: {
                run: 1..3,
                idle: 0..0,
                jump: 5..5,
                die: 6..6
            })
        @inMove = false
        @direction = 'd'
        @faceDirection = 'r'
        @jump = false
        @die = false 
        @died = false 
        @velocity_y = 0
        @touching_ground = false
        @win = false
        @died_ago=0
    end

    def change_move(event)
        case event.key
        when 'left'
            @sprite.play animation: :run, loop: true, flip: :horizontal
            @inMove=true
            @faceDirection='l'
            @direction = 'l'
        when 'right'
            @sprite.play animation: :run, loop: true
            @inMove=true
            @faceDirection='r'
            @direction = 'r'
        when 'up'
            if @faceDirection == 'r' then
                @sprite.play animation: :jump, loop: true
            else
                @sprite.play animation: :jump, loop: true, flip: :horizontal
            end
            @inMove=true
            @jump=true

      end
    end

    def stayInPlace(event)
        case event.key
        when 'left'
            @direction = 'd'
        when 'right'
            @direction = 'd'
        end
        if @faceDirection == 'r' then
            @sprite.play animation: :idle, loop: true
        end
        if @faceDirection == 'l' then
            @sprite.play animation: :idle, loop: true, flip: :horizontal
        end
    
        @inMove=false
    end

    def move(dt)

        @touching_ground=hasColision(@sprite.x, @sprite.y + 1)

        if @sprite.y + 1 > $window_height - $tile_size then
            @die = true
        end

        if @die then
            @sprite.play animation: :die, loop: true
            @sprite.y+=1
            @died_ago+=dt
            if  @sprite.y > $window_height or @died_ago > 0.5 then
                @died = true
            end
            return
        end
    
        fight_monsters()
        collect_coins()
        drop(dt, @sprite.x, @sprite.y, @jump)

        @sprite.y+=@velocity_y


        if @inMove then
            if @direction == 'r' then
                @sprite.x+=can_move_right(@sprite.x,@sprite.y,4)
            end
            if @direction == 'l' then
                @sprite.x-=can_move_left(@sprite.x,@sprite.y,4)
            end
 
            if @jump == true then
                if @touching_ground then
                    @velocity_y = -12
                end
                @jump=false
            end
            
        end

    end

    def collect_coins()
        for i in 0..$coins.size - 1 
            if has_dynamic_colision(@sprite.x,@sprite.y,$coins[i].x,$coins[i].y) then
                $points+=1
                $coins.delete_at(i)
                if $points== $points_to_win then
                    @win = true
                end
                break
            end
        end
    end

    def fight_monsters()
        for i in 0..$monsters.size - 1 
            if $monsters[i].die== false && has_dynamic_colision(@sprite.x,@sprite.y,$monsters[i].sprite.x,$monsters[i].sprite.y) then
                if ($monsters[i].sprite.y > @sprite.y) then
                    $monsters[i].sprite
                        $monsters[i].die=true
                        @velocity_y=-7
                        break
                else
                    @die = true
                    break
                end
            end
        end
    end

end