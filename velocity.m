function v = velocity(pos,vv)
    x = pos(1);
    y = pos(2);
    angle = rand*2*pi;
    set = false;
    count = 1;
    
    while set == false
        v(1) = (1/120)*cos(angle); %1/120
        v(2) = (1/120)*sin(angle);
        set = boundary(x+v(1),y+v(2));
        count = count+1;
        if count >1000
            disp('overflow!')
            if vv(1) == 0
                error('Oops.Bad initial position.Please excute again.')
            end
            v(1) = -vv(1);
            v(2) = -vv(2);
            break
        end
    end
        
