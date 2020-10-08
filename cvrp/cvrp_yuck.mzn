% CVRP model for Yuck
%
% Michael Marte, 2020

include "cvrp.mzn";
include "delivery.mzn";
include "giant_tour.mzn";

predicate track_times(
    set of int: StartNodes,
    set of int: EndNodes,
    array[int] of var int: succ,
    array[int] of var int: arrivalTimes,
    array[int, int] of int: TravelTimes,
    var int: totalTravelTime)
=
    delivery(StartNodes, EndNodes, succ, arrivalTimes, [], TravelTimes, false, totalTravelTime);

predicate track_loads(
    set of int: StartNodes,
    set of int: EndNodes,
    array[int] of var int: succ,
    array[int] of var int: loads,
    array[int] of int: Demands)
=
    delivery(StartNodes, EndNodes, succ, loads, Demands, [||], false, 0);

solve minimize totalTravelTime;
