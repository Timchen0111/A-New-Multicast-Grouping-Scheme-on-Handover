function g = add_remove(gNB,UE,command)
    g = gNB;
    if command == 1 %add UE         
        %disp('ADD UE')
        UE.num;
        if numel(find(g.waitingUE==UE.num))>0
            UE.num;
            g;
            error('repeat UE')
        end
        g.waitingUE(end+1) = UE.num;            
        end

    if command == 2 %remove UE
        %disp('REMOVE UE')
        UE.num;
        g.num;
        del = find(g.joinUE == UE.num);
        g.joinUE(del) = [];
        g.group(del) = [];

        clear ingroup
    end

    if command == 3 %add UE to SC group         
        %disp('ADD UE')
        UE.num;
        if numel(find(g.scUE==UE.num))>0
            UE.num;
            g;
            error('repeat UE')
        end
        if numel(find(g.joinUE==UE.num))>0
            UE.num;
            g;
            error('repeat UE on join')
        end
        g.scUE(end+1) = UE.num;            
    end

    