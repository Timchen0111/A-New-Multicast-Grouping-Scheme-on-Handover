function r = pathloss(Hbs,Hut,h,d2d,fc)
%calculate pathloss. Output is [pathloss,type(PL1 or PL2)]
d3d = sqrt((Hbs-Hut)^2+d2d^2);
c = 3e8;

if Hut < 13
    C_h = 0;
else
    C_h = ((Hut-13)/10)^1.5;
end

if d2d>18
    pr_los = (18/d2d+exp(-d2d/63)*(1-18/d2d))*(1+C_h*(5/4)*(d2d/100)^3*exp(-d2d/150));
else
    pr_los = 1;
end

LOS_test = rand();
if LOS_test<pr_los
    LOS = true;
else
    LOS = false;
end

dbp = 2*pi*Hbs*Hut*fc*(1e9)/c;
PL1 = 28+22*log10(d3d)+20*log10(fc);
PL2 = 28+40*log10(d3d)+20*log10(fc)-9*log10((dbp)^2+(Hbs-Hut)^2);
    
if d2d<dbp
    %PL1
    PL_los = PL1;
else
    %PL2
    PL_los = PL2;
end

if LOS == true
    PL = PL_los;
else
    %NLOS
    PL_nlos = 13.54+39.08*log10(d3d)+20*log10(fc)-0.6*(Hut-1.5);
    PL = max(PL_los,PL_nlos);
end
r = [PL LOS];