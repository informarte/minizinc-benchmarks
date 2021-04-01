% TSPTW model for CP solvers
%
% Michael Marte, 2020

include "circuit.mzn";
include "tsptw.mzn";

predicate giant_tour(
    set of int: StartNodes,
    set of int: EndNodes,
    array[int] of var int: succ)
=
    circuit(succ)
    /\ forall(i in min(EndNodes)..(max(EndNodes) - 1))(succ[i] = min(StartNodes) + (i - min(EndNodes)) + 1)
    /\ succ[max(EndNodes)] = min(StartNodes);

predicate track_times(
    set of int: StartNodes,
    set of int: EndNodes,
    array[int] of var int: succ,
    array[int] of var int: arrivalTimes,
    array[int, int] of int: TravelTimes,
    var int: totalTravelTime)
=
    let {
        set of int: Nodes = index_set(succ)
    }
    in forall(i in Nodes diff EndNodes)(
        let {
            var int: j = succ[i]
        }
        in arrivalTimes[j] >= arrivalTimes[i] + TravelTimes[i, j]
    )
    /\
    totalTravelTime = sum(i in Nodes diff EndNodes)(TravelTimes[i, succ[i]]);

solve
:: seq_search([
    int_search(succ, first_fail, indomain_split, complete),
    int_search(arrivalTimes, first_fail, indomain_min, complete)
])
minimize totalTravelTime;
