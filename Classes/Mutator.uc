class Mutator extends KFGame.KFMutator;

function bool CheckReplacement(Actor Other) {
    local PlayerReplicationInfo pri;

    if (PlayerReplicationInfo(Other) != none && Other.Owner != None && Other.Owner.IsA('PlayerController') && 
            PlayerController(Other.Owner).bIsPlayer) {
        pri= PlayerReplicationInfo(Other);

        Spawn(class'KF2StatsX.ReplicationInfo', pri.Owner);
    }
    return super.CheckReplacement(Other);
}

defaultproperties {
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=True
}
