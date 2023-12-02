% BlueScripters
function path = task_1(map, startPoint, stopPoint)
    % Binary Road Map
    % binaryMap = map(:,:,1);

    % Speed Limit Cost
    speedMap = map(:,:,2);

    % Traffic Intensity
    trafficMap = map(:,:,3);

    % Obstacle Cost
    obstacleMap = map(:,:,4);

    % Total Cost Map
    costMap = speedMap .* trafficMap + obstacleMap;
    costMap_normalized = costMap./max(max(costMap)); % Need to be normalized to 0-1 value

    % Planner A*
    costMap_normalized = costMap_normalized*0.98;
    costMap_normalized(costMap_normalized==0) = 1;
    occCostMap = occupancyMap(costMap_normalized);
    occCostMap.OccupiedThreshold = 0.99;
    occCostMap.FreeThreshold = 0.1;

    planner = plannerAStarGrid(occCostMap);
    path = plan(planner,startPoint,stopPoint);
    % show(planner)
end