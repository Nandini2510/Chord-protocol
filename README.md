# Chord Protocol
COP5615 - Distributed Operating Systems Principles Project 3

Implement the network join and routing as described in the Chord MIT paper using Actor Model in Erlang and encode an application which associates a key with a string. We have to use a similar API for the implementation part as described in the paper.

## Team Members
* **Sai Sandeep Edara** - *UF ID: 78776619*
* **Nandani Yadav** - *UF ID: 18186343*

## Contents of this file

Flow of Program, Prerequisites, Implementation, Instruction Section, What is working, Largest Network we managed to deal with

## Flow of Program

* For Chord Protocol

There are 2 arguments to be passed:

* Input Number of Nodes
* Input Number of requests



## Prerequisites

#### Erlang OTP 21(10.0.1)

## Implementation

1) Calculating Node Ids : We have used SHA-1 function i.e hashing to calculate ids of nodes which act as an actor using chord protocol
2) Finger Table : Each node keeps track of the m entries that is of its successor and predecessor nodes. The value of successor is calculated using 
(n+2^i-1) mod m) formula for ith node. Using this values, any node can look up for a key.


## Instruction section

#### To run the App

```erlang

$ cd Project3
$ c(mainProcess).
$ mainProcess:startProcess().
$ Enter <No. of Nodes> <No. of requests> 
SAMPLE O/P-> Average HopCount 
.................................................................................................................................................................

Time utilized to converge : xxxx milliseconds
```
Run the app, pass in No. of Nodes & No. of requests. The console prints the Number of hops, key values and nodes.


## What is working
By using chord protocol, we have set up the routing mechanism and node join by referring to the Chord MIT paper. Once the peer is being added to the overlay network, all peers start joining that network to form a DHT. Each node has its finger table which keeps track of their successors and predecessors nodes and every time a new node joins the network, the finger table gets updated.  All the nodes keep track of their successors using a finger table. One the nodes are set up in the network, delivery of messages begins. Each peer starts sending requests i.e request/second and this will continue until the desired “numRequests” value entered by the user is reached. We have implemented several functionalities such as finding successor, finding predecessor, finger table, finding nearest preceding peer and tracking number of hops. 
After completion the average number of hops count is displayed.



## Largest Network we managed to deal with:

The largest network our program ran successfully was for 20000 nodes.




