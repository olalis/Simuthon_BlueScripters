function [startPoint, stopPoint] = startStopGenerator(base_map_1)

    dLimit = 0.8*size(base_map_1,1);
    tempVar = find(double(base_map_1));
    randIdx = randi(length(tempVar));
    [y1, x1] = ind2sub(size(base_map_1),tempVar(randIdx));
    startPoint = [y1, x1];
    
    [tempVarY, tempVarX] = ind2sub(size(base_map_1),tempVar(:));
    
    all_d_x = tempVarX - x1;
    all_d_y = tempVarY - y1;
    all_d = sqrt(all_d_x.^2 + all_d_y.^2);
    maxDLimit = 0.7*max(all_d);
    
    d = 0;
    while d < min(dLimit,maxDLimit)
        randIdx = randi(length(tempVar));
        [y2, x2] = ind2sub(size(base_map_1),tempVar(randIdx));
    
        d = sqrt( (x2-x1)^2 + (y2-y1)^2 );
    end
    stopPoint = [y2, x2];

end

