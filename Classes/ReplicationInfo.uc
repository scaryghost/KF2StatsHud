class ReplicationInfo extends Engine.ReplicationInfo;

simulated event Tick(float DeltaTime) {
    local PlayerController localController;
    local Interaction interaction;

    localController= GetALocalPlayerController();
    if (localController != none && localController.IsA('KFPlayerController')) {
        interaction = new class'KF2StatsX.Interaction';
        interaction.owner = KFPlayerController(localController);
        localController.Interactions.InsertItem(0, interaction);
    }
    Disable('Tick');
}
