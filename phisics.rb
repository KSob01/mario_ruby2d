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


def has_static_colision(x_coord,y_coord)
    tiles_range = tiles_that_colide(x_coord,y_coord)
        
    for i in 0 .. tiles_range.size - 1
        if $level_map[tiles_range[i][1]][tiles_range[i][0]] != 0 then
            return true
        end
    end
    return false
end

def has_dynamic_colision(x_coord_1,y_coord_1,x_coord_2,y_coord_2)
    return (x_coord_1 - x_coord_2).abs <= $tile_size && (y_coord_1 - y_coord_2).abs <= $tile_size
end

def hasColision(x_coord, y_coord)
    if y_coord > $window_height - $tile_size or x_coord < 0 or x_coord > $window_width - $tile_size then
        return true
    end

    return has_static_colision(x_coord,y_coord)
end


def can_move_right(x_coord,y_coord,v)
    move_right=0
    for i in 1 .. v
        if !hasColision(x_coord + i, y_coord) then
            move_right+=1
        else
            break
        end
    end
    return move_right
end

def can_move_left(x_coord,y_coord,v)
    move_left=0
    for i in 1 .. v
        if !hasColision(x_coord - i, y_coord) then
            move_left+=1
        else
            break
        end
    end
    return move_left
end

def how_far_from_ground(y_coord)
    return $tile_size - y_coord % $tile_size
end


def drop(dt, x_coord, y_coord, can_jump)
    if @touching_ground && can_jump ==  false then
        @velocity_y = 0
    else
        @velocity_y+=dt*20
        if @touching_ground == false && hasColision(x_coord, y_coord + @velocity_y) then
            if @velocity_y > 0  then
                @velocity_y = how_far_from_ground(y_coord)
            else
                @velocity_y = 0
            end
            
        end
    end
end



