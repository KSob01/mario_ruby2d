class Coin
    attr_accessor :x, :y
    def initialize (x_start,y_start)
        @x=x_start
        @y=y_start
        @velocity_y = 0
    end

    def move(dt)
        @touching_ground = hasColision(@x, @y + 1)
        drop(dt, @x, @y, false)
        @y+=@velocity_y
        
    end
end
