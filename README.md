A New Multicast Grouping Scheme on Handover
=================================
#### This code is for "A New Multicast Grouping Scheme on Handover". ####

To use the simulation code, you have to execute "main.m" by typing the following command:
```
main("NAME-OF-SCHEME","NUMBER OF UE","SIMULATION TIME")
```
#### Available schemes for this code: ####

* "kmeans": Regrouping with K-means algorithm. Ping-pong effect is not considered.

* "random": Regrouping randomly. Ping-pong effect is not considered.

* "GRPPD": Regrouping with K-means algorithm. Put UEs in ping-pong movement into a special group.

* "GKPPD": Regrouping with K-means algorithm. Put UEs in ping-pong movement into a special group.

* "GRPPD-UNI": Regrouping with K-means algorithm. Put UEs in ping-pong movement into unicast.

* "GKPPD-UNI": Regrouping with K-means algorithm. Put UEs in ping-pong movement into unicast.



The unit of simulation time is second.
