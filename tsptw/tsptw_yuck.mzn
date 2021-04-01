% TSPTW model for Yuck
%
% Michael Marte, 2020

include "tsptw.mzn";
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
    delivery(StartNodes, EndNodes, succ, arrivalTimes, [], TravelTimes, true, totalTravelTime);

solve minimize totalTravelTime;
