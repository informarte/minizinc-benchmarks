% CVRPTW model for Yuck
%
% Michael Marte, 2020

include "cvrptw.mzn";
include "delivery.mzn";
include "giant_tour.mzn";

predicate track_times(
    set of int: StartNodes,
    set of int: EndNodes,
    array[int] of var int: succ,
    array[int] of var int: arrivalTimes,
    array[int] of int: ServiceTimes,
    array[int, int] of int: TravelTimes,
    var int: totalTravelTime)
=
    delivery(StartNodes, EndNodes, succ, arrivalTimes, ServiceTimes, TravelTimes, true, totalTravelTime);

predicate track_loads(
    set of int: StartNodes,
    set of int: EndNodes,
    array[int] of var int: succ,
    array[int] of var int: loads,
    array[int] of int: Demands)
=
    delivery(StartNodes, EndNodes, succ, loads, Demands, [||], false, 0);

solve minimize totalTravelTime;
