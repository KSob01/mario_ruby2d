class Monster
    attr_accessor :sprite, :die

    def initialize (x_start,y_start, direction)
        @sprite = Sprite.new(
            'assets/monster.png',
            x: x_start, 
            y: y_start,
            width: $tile_size,
            height: $tile_size,
            clip_width: 16,
            time: 80,
            animations: {
                run: 0..1,
                die: 2..2
            })
        @velocity_y = 0
        @died_ago = 0
        @die=false
        @direction = direction
    end

    def move(dt)
        if  @die then
            @died_ago+=dt
            if @died_ago < 0.1 then
                @sprite.play animation: :die, loop: true
                return
            else
                @sprite.remove
                return
            end
        end

        @touching_ground=hasColision(@sprite.x, @sprite.y + 1)

        if @touching_ground then
            @sprite.play animation: :run, loop: true
        end

        
        if @direction == 'r' then
            to_move=can_move_right(@sprite.x,@sprite.y,1)
            if to_move!=0 then
                @sprite.x+=to_move
            else
                @direction = 'l'
            end

        end

        if @direction == 'l' then
            to_move= can_move_left(@sprite.x,@sprite.y,1)
            if to_move!=0 then
                @sprite.x-=to_move
            else
                @direction = 'r'
            end
        end

        drop(dt, @sprite.x, @sprite.y, false)
        @sprite.y+=@velocity_y
    end



    
end