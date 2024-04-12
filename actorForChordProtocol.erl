-module(actorForChordProtocol).
-export([closestValueToGivenValue/4, startNode/0]).


startNode()->
    receive
        {CurrentNode, N, CurrentValue, Counter}->
            F = trunc(math:log2(N))-1,
            Z = closestValueToGivenValue(CurrentNode, N, CurrentValue, F),
            if
                Z == CurrentValue ->
                    chordProtocolServer ! {Counter},
                    startNode();
                true ->
                    CurrentID = integer_to_list(Z),
                    list_to_atom("node"++CurrentID) ! {Z, N, CurrentValue, Counter + 1},
                    startNode()
            end,
            startNode()
    end.

closestValueToGivenValue(CurrentNode, N, CurrentValue, F)->
    if
        F == 0 ->
            E = CurrentNode + 1,
            if
                E > N ->
                   TotalNumberOfNodesInTheNetwork = (E rem N); 
                true ->
                    TotalNumberOfNodesInTheNetwork = E
            end;
        true ->
            B = CurrentNode + trunc(math:pow(2, F)),
            FirstValue = closestValueToGivenValue(CurrentNode, N, CurrentValue, F - 1),
            if
                B > N ->
                   SecondValue = B rem N; 
                true ->
                    SecondValue = B
            end,
            if
                ((CurrentValue - FirstValue >= 0) and (CurrentValue - SecondValue >= 0)) ->
                    if
                        FirstValue > SecondValue->
                            TotalNumberOfNodesInTheNetwork = FirstValue;
                        true ->
                            TotalNumberOfNodesInTheNetwork = SecondValue
                    end;
                true ->
                    if (CurrentValue - FirstValue) >= 0 ->
                        TotalNumberOfNodesInTheNetwork = FirstValue;
                    true ->
                        if (CurrentValue - SecondValue) >= 0 ->
                            TotalNumberOfNodesInTheNetwork = SecondValue;
                        true ->
                            if
                                FirstValue>SecondValue ->
                                    TotalNumberOfNodesInTheNetwork = FirstValue;
                                true ->
                                    TotalNumberOfNodesInTheNetwork = SecondValue
                            end
                        end
                    end
            end
    end,
    TotalNumberOfNodesInTheNetwork.

shaValueComputer(Node) ->
    base64:encode(crypto:strong_rand_bytes(12)).