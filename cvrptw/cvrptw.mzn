% Capacitated VRP with service times and time windows
%
% Michael Marte, 2020

include "vrp.mzn";

% for tracking arrival times and total travel time
predicate track_times(
    set of int: StartNodes,
    set of int: EndNodes,
    array[int] of var int: succ,
    array[int] of var int: arrivalTimes,
    array[int] of int: ServiceTimes,
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

% scaling factor (for improving precision)
int: Scale;

% rounding modes
enum RoundingMode = {Floor, NearestInteger};

% service times
array[CityNodes] of int: ServiceTimes;
array[Nodes] of int: GiantTourServiceTimes =
    [if i in CityNodes then Scale * ServiceTimes[i] else 0 endif | i in Nodes];

% travel times
RoundingMode: DistanceRoundingMode;
array[0..N] of int: X; % (x[0], y[0]) is location of depot
array[0..N] of int: Y;
function int: euclidean_distance(int: i, int: j) =
    let {int: xd = X[i] - X[j],
         int: yd = Y[i] - Y[j],
         float: d = Scale * sqrt(xd * xd + yd * yd)}
    in if DistanceRoundingMode = Floor then floor(d) else floor(d + 0.5) endif;
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
array[1..2, {DepotNode} union CityNodes] of int: TimeWindows;
array[Nodes] of var int: arrivalTimes;
constraint forall(i in StartNodes)(arrivalTimes[i] = Scale * TimeWindows[1, DepotNode]);
constraint forall(i in EndNodes)(
    arrivalTimes[i] in (Scale * TimeWindows[1, DepotNode])..(Scale * TimeWindows[2, DepotNode])
);
constraint forall(i in CityNodes)(
    arrivalTimes[i] in (Scale * TimeWindows[1, i])..(Scale * TimeWindows[2, i])
);
var 0..sum(i in Nodes)(max([GiantTourTravelTimes[i, j] | j in Nodes])): totalTravelTime;
constraint
    track_times(
        StartNodes, EndNodes, succ, arrivalTimes, GiantTourServiceTimes, GiantTourTravelTimes,
        totalTravelTime);

% demands
array [CityNodes] of int: Demands;
array[Nodes] of int: GiantTourDemands =
    [if i in CityNodes then Demands[i] else 0 endif | i in Nodes];

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
