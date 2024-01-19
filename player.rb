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

        when 'down'
            @sprite.play animation: :die, loop: true
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

        if @die then
            @sprite.play animation: :die, loop: true
            @sprite.y+=0.5
            if  @sprite.y > $window_height then
                @died = true
            end
            return
        end
    

        if @touching_ground && @jump == false then
            @velocity_y = 0
        else
            @velocity_y+=dt*20
            if @touching_ground == false && hasColision(@sprite.x, @sprite.y + @velocity_y) then
                if @velocity_y > 0  then
                    @velocity_y = $tile_size - @sprite.y % $tile_size
                else
                    @velocity_y = 0
                end
                
            end
        end

        @sprite.y+=@velocity_y


        if @inMove then
            if @direction == 'r' then
                for i in 1 .. 4
                    if !hasColision(@sprite.x+1, @sprite.y) then
                        @sprite.x+=1
                    end
                end
            end
            if @direction == 'l' then
                for i in 1 .. 4
                    if !hasColision(@sprite.x-1, @sprite.y) then
                        @sprite.x-=1
                    end
                end
            end
 
            if @jump == true then
                if @touching_ground then
                    @velocity_y = -12
                    
                end
                @jump=false
            end
            
        end


    end

    def hasColision(x_coord, y_coord)
        if y_coord > $window_height - $tile_size then
            @die = true
            return true
        end

        if x_coord < 0 or x_coord > $window_width - $tile_size then
            return true
        end

        tiles_range = tiles_that_colide(x_coord,y_coord)

        
        for i in 0 .. tiles_range.size - 1
            if $level_map[tiles_range[i][1]][tiles_range[i][0]] != 0 then
                return true
            end
        end
        return false
    end

    def tiles_that_colide(x_coord, y_coord)
        tiles_range=[]

        tile_x =  x_coord / $tile_size
        tile_y = y_coord / $tile_size
        if (x_coord % $tile_size) ==  0 then

           if (y_coord % $tile_size) ==  0 then
                tiles_range.append([tile_x, tile_y])
           else
                tiles_range.append([tile_x, tile_y])
                tiles_range.append([tile_x, tile_y + 1])
            end
        else
            if (y_coord % $tile_size) ==  0 then
                tiles_range.append([tile_x, tile_y])
                tiles_range.append([tile_x + 1, tile_y])
           else
                tiles_range.append([x_coord / $tile_size, tile_y])
                tiles_range.append([x_coord / $tile_size, tile_y + 1])
                tiles_range.append([x_coord / $tile_size + 1, tile_y])
                tiles_range.append([x_coord / $tile_size + 1, tile_y + 1])
            end
        end
        return tiles_range
    end

end