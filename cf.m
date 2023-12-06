function r = cf(x)
    cd = 10;  %corrlation distance(para)
    r = exp(-x/cd);