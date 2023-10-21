function judge = boundary(x,y,gNB)
if sqrt(x^2+y^2) > 850 %1.8*500
    judge = false;
    return
else
    judge = true;
end
for i = 1:19
    if norm(gNB(i).pos-[x,y])<35
        judge = false;
        return
    end
end