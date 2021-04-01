% VRP model based on giant-tour representation
%
% Michael Marte, 2020

% problem dimensions and derived constants
int: N; % number of cities
int: MinK; % minimum number of vehicles/ tours
int: MaxK; % maximum number of vehicles/ tours
int: DepotNode = 0; % index of depot node in input data
set of int: CityNodes = 1..N; % indices of city nodes
set of int: StartNodes = (N + 1)..(N + MaxK); % indices of artificial start nodes (one per vehicle/ tour)
set of int: EndNodes = (N + MaxK + 1)..(N + 2 * MaxK); % indices of artificial end nodes (one per vehicle/ tour)
set of int: Nodes = 1..(N + 2 * MaxK); % indices of all nodes excluding the real depot node

% Hamiltonian circuit where start nodes succeed end nodes
array[Nodes] of var Nodes: succ;
predicate giant_tour(set of int: StartNodes, set of int: EndNodes, array[int] of var int: succ);
constraint giant_tour(StartNodes, EndNodes, succ);
