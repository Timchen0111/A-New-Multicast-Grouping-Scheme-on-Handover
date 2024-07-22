function v = velocity(pos,vv,gNB)
    x = pos(1);
    y = pos(2);
    angle = rand*2*pi;
    set = false;
    count = 1;
    %3km/hr = 3000m/hr = 10/12m/s = 1/12 m/(0.1s)
    vvv = 1/1.2;
    while set == false
        v(1) = (vvv)*cos(angle); %Now: 60km/hr
        v(2) = (vvv)*sin(angle);
        set = boundary(x+v(1),y+v(2),gNB);
        count = count+1;
        if count>10000
            if numel(vv)>0
                disp('overflow!')                
                v(1) = -vv(1);
                v(2) = -vv(2);
                break  
            else                
                length = sqrt(x^2+y^2);
                v(1) = -(vvv)*x/length;
                v(2) = -(vvv)*y/length;
                break
            end
        end
    end
        
        
