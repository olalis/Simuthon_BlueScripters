% BlueScripters
function path = task_1_visualization(map, startPoint, stopPoint)  
    %% Unpacking map struct
    % binaryMap = map(:,:,1);   % Binary Road Map
    speedMap = map(:,:,2);      % Speed Limit Cost Map
    trafficMap = map(:,:,3);    % Traffic Intensity Map
    obstacleMap = map(:,:,4);   % Obstacle Cost Map
    
    %% Total Cost Map Calculation
    costMap = speedMap .* trafficMap + obstacleMap;     % Based on doc equation
    costMap_normalized = costMap./max(max(costMap));    % Normalization to 0-1 value

    %% Planner A*
    costMap_normalized = costMap_normalized*0.98;       % Rescaling cost map
    costMap_normalized(costMap_normalized==0) = 1;      % Setting up everything that is not road as an obstacle (cost = 1)
    occCostMap = occupancyMap(costMap_normalized);      % Creating occupancyMap object based on costMap
    occCostMap.OccupiedThreshold = 0.99;                % Setting occupancyMap parameters
    occCostMap.FreeThreshold = 0.1;

    planner = plannerAStarGrid(occCostMap);             % Creating A* planner object
    path = plan(planner,startPoint,stopPoint);          % Path calculation
    show(planner)
end