s = Semaphore();
s.release();
parfor i = 1:4
    r = main(5,10,20,3,10.24,6,s);
end