function judge = boundary(x,y)
if sqrt(x^2+y^2) > 900 %1.8*500
    judge = false;
else
    judge = true;
end
