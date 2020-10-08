% Capacitated VRP
%
% Michael Marte, 2020

include "vrp.mzn";

% for tracking arrival times and total travel time
predicate track_times(
    set of int: StartNodes,
    set of int: EndNodes,
    array[int] of var int: succ,
    array[int] of var int: arrivalTimes,
    array[int, int] of int: TravelTimes,
    var int: totalTravelTime);

% for tracking vehicle loads
predicate track_loads(
    set of int: StartNodes,
    set of int: EndNodes,
    array[int] of var int: succ,
    array[int] of var int: loads,
    array[int] of int: Demands);

% maximum number of vehicles/ tours
float: MaxKToMinKRatio;
MaxK = min(N, floor(MinK * MaxKToMinKRatio));

% travel times
array[0..N] of int: X; % (x[0], y[0]) is location of depot
array[0..N] of int: Y;
function int: euclidean_distance(int: i, int: j) =
    let {int: xd = X[i] - X[j], int: yd = Y[i] - Y[j]}
    in floor(sqrt(xd * xd + yd * yd) + 0.5);
array[Nodes, Nodes] of int: GiantTourTravelTimes = array2d(Nodes, Nodes, [
    if i in CityNodes /\ j in CityNodes then
         euclidean_distance(i, j)
    elseif i in CityNodes /\ not (j in CityNodes) then
         euclidean_distance(i, DepotNode)
    elseif not (i in CityNodes) /\ j in CityNodes then
        euclidean_distance(DepotNode, j)
    else
        euclidean_distance(DepotNode, DepotNode)
    endif
    | i, j in Nodes]);

% arrival times
set of int: Time = 0..sum(i in Nodes)(max([GiantTourTravelTimes[i, j] | j in Nodes]));
array[Nodes] of var Time: arrivalTimes;
constraint forall(i in StartNodes)(arrivalTimes[i] = 0);
var Time: totalTravelTime;
constraint track_times(StartNodes, EndNodes, succ, arrivalTimes, GiantTourTravelTimes, totalTravelTime);

% demands
array [CityNodes] of int: Demands;
array[Nodes] of int: GiantTourDemands = [if i in CityNodes then Demands[i] else 0 endif | i in Nodes];

% vehicle capacities and loads
int: Capacity;
set of int: Load = 0..Capacity;
array[Nodes] of var Load: loads;
constraint forall(i in StartNodes)(loads[i] = 0);
constraint track_loads(StartNodes, EndNodes, succ, loads, GiantTourDemands);

output [
    "totalTravelTime = ", show(totalTravelTime), ",\n",
    "arrivalTimes = ", show(arrivalTimes), ",\n",
    "succ = ", show(succ)];
