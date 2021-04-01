% TSP with time windows
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

% one vehicle
MinK = 1;
MaxK = 1;

% travel times
array[{DepotNode} union CityNodes, {DepotNode} union CityNodes] of int: TravelTimes;
array[Nodes, Nodes] of int: GiantTourTravelTimes = array2d(Nodes, Nodes, [
    if i in CityNodes /\ j in CityNodes then
         TravelTimes[i, j]
    elseif i in CityNodes /\ not (j in CityNodes) then
         TravelTimes[i, DepotNode]
    elseif not (i in CityNodes) /\ j in CityNodes then
        TravelTimes[DepotNode, j]
    else
        TravelTimes[DepotNode, DepotNode]
    endif
    | i, j in Nodes]);

% arrival times
array[1..2, {DepotNode} union CityNodes] of int: TimeWindows;
array[Nodes] of var int: arrivalTimes;
constraint forall(i in StartNodes)(arrivalTimes[i] = TimeWindows[1, DepotNode]);
constraint forall(i in EndNodes)(arrivalTimes[i] in TimeWindows[1, DepotNode]..TimeWindows[2, DepotNode]);
constraint forall(i in CityNodes)(arrivalTimes[i] in TimeWindows[1, i]..TimeWindows[2, i]);
var 0..sum(i in Nodes)(max([GiantTourTravelTimes[i, j] | j in Nodes])): totalTravelTime;
constraint track_times(StartNodes, EndNodes, succ, arrivalTimes, GiantTourTravelTimes, totalTravelTime);

output [
    "totalTravelTime = ", show(totalTravelTime), ",\n",
    "arrivalTimes = ", show(arrivalTimes), ",\n",
    "succ = ", show(succ)];
