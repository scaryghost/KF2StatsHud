class ReplicationInfo extends Engine.ReplicationInfo;

simulated event Tick(float DeltaTime) {
    local PlayerController localController;
    local Interaction interaction;

    localController= GetALocalPlayerController();
    if (localController != none && localController.IsA('KFPlayerController')) {
        interaction = new class'StatsHud.Interaction';
        interaction.OnInitialize();
        interaction.owner = KFPlayerController(localController);
        localController.Interactions.InsertItem(0, interaction);
    }
    Disable('Tick');
}
