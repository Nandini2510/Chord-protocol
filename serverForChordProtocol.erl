-module(serverForChordProtocol).
-export([startServer/0, findANode/5, registerNodes/1]).

startServer()->
    
    {ok, [TotalNumberOfNodesInTheNetwork]} = io:fread("Please enter the number of nodes in the network: ", "~d"),
    {ok, [NumberOfRequestsPerNodeRemaining]} = io:fread("Please enter the number of requests per node in the network: ", "~d"),

    Y = trunc(math:log2(TotalNumberOfNodesInTheNetwork)),
    N = trunc(math:pow(2, Y)),

    registerNodes(N),
    register(chordProtocolServer, spawn(serverForChordProtocol, findANode, [N, N, NumberOfRequestsPerNodeRemaining - 1, NumberOfRequestsPerNodeRemaining, 0])).


registerNodes(N)->
    if
        N == 0 ->
            ok;
        true ->
            CurrentID = integer_to_list(N),
            register(list_to_atom("node" ++ CurrentID), spawn(actorForChordProtocol, startNode, [])),
            registerNodes(N - 1)
    end.


findANode(CurrentNode, N, NumberOfRequestsPerNodeRemaining, GivenNumberOfRequestsPerNode, TotalNumberOfHopsUntilNow)->
    if
        CurrentNode == 0 ->
            if
                NumberOfRequestsPerNodeRemaining == 0 ->
                    io:format("The total number of hops that took place in the given network is ~p ~n",[TotalNumberOfHopsUntilNow]),
                    T=(N * GivenNumberOfRequestsPerNode),
                    Avghops = TotalNumberOfHopsUntilNow / T,
                    io:format("The average number of hops in the network is ~p ~n", [Avghops]);
                true ->
                    findANode(N, N, NumberOfRequestsPerNodeRemaining - 1, GivenNumberOfRequestsPerNode, TotalNumberOfHopsUntilNow)
            end;
        true ->
            Z = rand:uniform(N),
            if
                CurrentNode == Z ->
                    findANode(CurrentNode - 1, N, NumberOfRequestsPerNodeRemaining, GivenNumberOfRequestsPerNode, TotalNumberOfHopsUntilNow);
                true ->
                    Counter = 1,
                    CurrentID = integer_to_list(CurrentNode),
                    list_to_atom("node" ++ CurrentID) ! {CurrentNode, N, Z, Counter},
                    receive
                        {NumberOfHopsDoneForThisNode}->
                            io:format("Found key ~w~n", [Z]),
                            io:format("Hops done is ~w~n", [NumberOfHopsDoneForThisNode]),
                            findANode(CurrentNode - 1, N, NumberOfRequestsPerNodeRemaining, GivenNumberOfRequestsPerNode, TotalNumberOfHopsUntilNow + NumberOfHopsDoneForThisNode)
                    end
            end 
    end.