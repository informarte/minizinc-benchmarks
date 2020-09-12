include "circuit.mzn";

int: nbVehicles;
int: nbCustomers;
int: timeBudget;

set of int: VEHICLE = 1..nbVehicles;
set of int: CUSTOMER = 1..nbCustomers;
set of int: TIME = 0..timeBudget;
set of int: NODES = 1..nbCustomers+2*nbVehicles;
set of int: DEPOT_NODES = nbCustomers+1..nbCustomers+2*nbVehicles;
set of int: START_DEPOT_NODES = nbCustomers+1..nbCustomers+nbVehicles;
set of int: END_DEPOT_NODES = nbCustomers+nbVehicles+1..nbCustomers+2*
    nbVehicles;

array[int] of int: weights;
set of int: SC = index_set(weights);
array[SC, NODES, NODES] of int: distance;
array[SC, NODES] of var NODES: successor;
array[SC, NODES] of var NODES: predecessor;
array[NODES] of var VEHICLE: vehicle;
array[SC, NODES] of var TIME: arrivalTime;
array[NODES] of int: serviceTime;

constraint forall ( sc in SC ) ( 
    forall ( n in nbCustomers+2..nbCustomers+nbVehicles ) ( 
        predecessor[sc, n]==n+nbVehicles-1 
    ) 
);
constraint forall ( sc in SC ) ( 
    predecessor[sc, nbCustomers+1]==nbCustomers+2*nbVehicles 
);
constraint forall ( sc in SC ) ( 
    forall ( n in nbCustomers+nbVehicles+1..nbCustomers+2*nbVehicles-1 ) ( 
        successor[sc, n]==n-nbVehicles+1 
    ) 
);
constraint forall ( sc in SC ) ( 
    successor[sc, nbCustomers+2*nbVehicles]==nbCustomers+1 
);
constraint forall ( n in START_DEPOT_NODES ) ( vehicle[n]==n-nbCustomers );
constraint forall ( n in END_DEPOT_NODES ) ( 
    vehicle[n]==n-nbCustomers-nbVehicles 
);
constraint forall ( sc in SC ) ( 
    forall ( n in START_DEPOT_NODES ) ( arrivalTime[sc, n]==0 ) 
);
constraint forall ( sc in SC ) ( 
    forall ( n in NODES ) ( successor[sc, predecessor[sc, n]]==n ) 
);
constraint forall ( sc in SC ) ( 
    forall ( n in NODES ) ( predecessor[sc, successor[sc, n]]==n ) 
);
constraint forall ( sc in SC ) ( circuit ( i in NODES ) ( successor[sc, i] ) 
);
constraint forall ( sc in SC ) ( 
    circuit ( i in NODES ) ( predecessor[sc, i] ) 
);
constraint forall ( sc in SC ) ( 
    forall ( n in CUSTOMER ) ( vehicle[predecessor[sc, n]]==vehicle[n] ) 
);
constraint forall ( sc in SC ) ( 
    forall ( n in CUSTOMER ) ( vehicle[successor[sc, n]]==vehicle[n] ) 
);
constraint forall ( sc in SC ) ( 
    forall ( n in CUSTOMER ) ( 
        arrivalTime[sc, n]+serviceTime[n]+distance[sc, n, successor[sc, n]]<=
    arrivalTime[sc, successor[sc, n]] 
    ) 
);
constraint forall ( sc in SC ) ( 
    forall ( n in START_DEPOT_NODES ) ( 
        arrivalTime[sc, n]+serviceTime[n]+distance[sc, n, successor[sc, n]]<=
    arrivalTime[sc, successor[sc, n]] 
    ) 
);

var 0..timeBudget*2*max(weights): objective;
constraint 
   objective = sum ( sc in SC ) ( weights[sc]*max ( i in NODES ) ( arrivalTime[sc, i] ) );
solve :: seq_search([ int_search(vehicle, first_fail, indomain_min, complete),
                      int_search([successor[sc,j] | sc in SC, j in NODES], 
                                 first_fail, indomain_min, complete),
                      int_search([arrivalTime[sc,n] | sc in SC, n in NODES], 
                                 first_fail, indomain_min, complete)
                    ])                 
   minimize objective;

output [
    "successor = array2d(SC, ", show(NODES), ", ", show(successor), ");\n",
    "predecessor = array2d(SC, ", show(NODES), ", ", show(predecessor), ");\n",
    "vehicle = ", show(vehicle), ";\n",
    "arrivalTime = array2d(SC, ", show(NODES), ", ", show(arrivalTime), ");\n",
    "objective = ", show(objective), ";\n"
];
