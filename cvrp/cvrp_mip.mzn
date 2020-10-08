%------------------------------------------------------------------------------%
% vrp.mzn
% Jakob Puchinger
% July 2009
% vim: ft=zinc ts=4 sw=4 et tw=0
%------------------------------------------------------------------------------%

    % Number of customers
int: N;
    % Vehicle Capacity
int: Capacity;
    % Number of vehicles
int: MinK;
bool: FixedK;
int: K = MinK;
    % Customer demands
array[1..N] of int: Demands;
    % (x[0], y[0]) is location of depot
array[0..N] of int: X;
array[0..N] of int: Y;
    % Distances between the nodes (node 0 is depot)
function int: euclidean_distance(int: i, int: j) =
  let {int: xd = X[i] - X[j], int: yd = Y[i] - Y[j]}
  in floor(sqrt(xd * xd + yd * yd) + 0.5);
array[0..N, 0..N] of int: Distances =
    array2d(0..N, 0..N, [euclidean_distance(i, j) | i, j in 0..N]);
    % Decision variables, is arc ij part of a route? (node 0 is depot)
array[0..N, 0..N] of var 0..1: p;
    % Additional variables representing the load of vehicle after visiting
    % node i for subtour elimination
array[1..N] of var 0..Capacity: loads;

    % Indegree constraints
constraint
    forall(j in 1..N)(
        sum(i in 0..N)(p[i, j]) = 1
    );
    
    % Outdegree constraints
constraint
    forall(i in 1..N)(
        sum(j in 0..N)(p[i, j]) = 1
    );

    % Indegree Depot
constraint
    sum(i in 0..N)(p[i, 0]) <= K;

    % Outdegree Depot
constraint
    sum(j in 0..N)(p[0, j]) <= K;

    % Subtour elimination (Miller, Tucker Zemlin)
constraint
    forall( i in 1..N, j in 1..N)(
        loads[i] - loads[j] + Capacity * p[i, j] <= Capacity - Demands[j]
    )
    /\ forall(i in 1..N)(
        Demands[i] <= loads[i]
    );

var int: objective =
    sum( i in 0..N, j in 0..N ) (Distances[i, j] * p[i, j]);

solve 
    :: int_search(loads ++ [p[i, j] | i in 1..N, j in 1..N],
        first_fail, indomain_min, complete) 
    minimize objective;

output [
    "p = ", show(p), "\n",
    "objective = ", show(objective),"\n"
];
