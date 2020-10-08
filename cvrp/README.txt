Capacitated Vehicle Routing Problem
===================================

cvrp_mip.mzn      MIP formulation

cvrp_cp.mzn       CP formulation (using the formulation from the CP
                  handbook with the giant tour representation and
                  the circuit constraint)

cvrp_yuck.mzn     Model for Yuck (using the delivery constraint)

Augerat           74 instances proposed by Augerat et al. [1]
Uchoa             100 instances proposed by Uchoa et al. [2]

The Augerat instances are available from [3], [4], and [5] together
with the best known solutions.

The Uchoa instances are available from [4] and [5] together with the
best known solutions. In contrast to the Augerat instances, the Uchoa
instances do not fix the number of vehicles.


[1] P. Augerat, J. Belenguer, E. Benavent, A. Corberan, D. Naddef,
G. Rinaldi. Computational results with a branch and cut code for the
capacitated vehicle routing problem. Technical Report 949-M,
Universite Joseph Fourier, Grenoble (1995)

[2] E. Uchoa, D. Pecin, A. Pessoa, M. Poggi, A. Subramanian,
T. Vidala. New Benchmark Instances for the Capacitated Vehicle Routing
Problem. European Journal of Operational Research, Volume 257, Issue
3, 2017

[3] http://neo.lcc.uma.es/vrp

[4] http://vrp.galgos.inf.puc-rio.br/

[5] http://akira.ruc.dk/~keld/research/LKH-3/
