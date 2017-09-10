class ReplicationInfo extends Engine.ReplicationInfo;

var private bool initialized;

simulated event Tick(float DeltaTime) {
    local PlayerController localController;

    if (!initialized) {
        localController= GetALocalPlayerController();
        if (localController != none) {
            localController.Interactions.InsertItem(0, new class'Interaction');
        }
        initialized= true;
    }
}
