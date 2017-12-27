class Interaction extends Engine.Interaction
    config(Input);

var globalconfig name nextGroup;

var private array<Overlay> statDrawers;
var private int currentStat;

var KFPlayerController owner;

function Initialized() {
    if (nextGroup == '') {
        nextGroup = 'F4';
        SaveConfig();
    }
}

function bool keyEvent(int ControllerId, name Key, EInputEvent EventType, optional float AmountDepressed=1.f,
        optional bool bGamepad) {
    if (Key == nextGroup && EventType == IE_Pressed) {
        currentStat++;
        if (currentStat == statDrawers.length) {
            currentStat = -1;
        }
        return true;
    }
    return false;
}

event PostRender(Canvas canvas) {
    if (currentStat != -1) {
        statDrawers[currentStat].draw(owner, canvas, 0, owner.myHUD.SizeY / 2);
    }
}

function int weaponLength(KFPlayerController controller) {
    return controller.MatchStats.WeaponDamageList.Length;
}
function String weaponName(KFPlayerController controller, int i) {
    return controller.MatchStats.WeaponDamageList[i].WeaponDef.static.GetItemName();
}
function String weaponPrimary(KFPlayerController controller, int i) {
    return string(controller.MatchStats.WeaponDamageList[i].Kills);
}
function String weaponSecondary(KFPlayerController controller, int i) {
    return "";
}

function int killLength(KFPlayerController controller) {
    return controller.MatchStats.ZedKillsArray.Length;
}
function String killName(KFPlayerController controller, int i) {
    return Localize("Zeds", String(controller.MatchStats.ZedKillsArray[i].MonsterClass.default.LocalizationKey), "KFGame");
}
function String killPrimary(KFPlayerController controller, int i) {
    return string(controller.MatchStats.ZedKillsArray[i].KillCount);
}
function String killSecondary(KFPlayerController controller, int i) {
    return "";
}

function int perkLength(KFPlayerController controller) {
    return controller.MatchStats.PerkXPList.Length;
}
function String perkName(KFPlayerController controller, int i) {
    return controller.MatchStats.PerkXPList[i].PerkClass.default.PerkName;
}
function String perkPrimary(KFPlayerController controller, int i) {
    return string(controller.MatchStats.PerkXPList[i].XPDelta);
}
function String perkSecondary(KFPlayerController controller, int i) {
    return string(controller.MatchStats.PerkXPList[i].SecondaryXPGain);
}

defaultproperties
{
    currentStat=-1
    OnReceivedNativeInputKey=keyEvent

    Begin Object Class=Overlay Name=drawWeapon
        title="Weapons"
        getLength=weaponLength
        getItemName=weaponName
        getPrimaryValue=weaponPrimary
        getSecondaryValue=weaponSecondary
    End Object
    Begin Object Class=Overlay Name=drawKill
        title="Kills"
        getLength=killLength
        getItemName=killName
        getPrimaryValue=killPrimary
        getSecondaryValue=killSecondary
    End Object
    Begin Object Class=Overlay Name=drawPerk
        title="Perks"
        getLength=perkLength
        getItemName=perkName
        getPrimaryValue=perkPrimary
        getSecondaryValue=perkSecondary
    End Object

    statDrawers[0]=drawWeapon;
    statDrawers[1]=drawKill;
    statDrawers[2]=drawPerk;
}
