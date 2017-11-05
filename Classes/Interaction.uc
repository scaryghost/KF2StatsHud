class Interaction extends Engine.Interaction
    config(Input);

var globalconfig name nextGroup;

var private Texture2D txtBackground;
var private Color backgroundColor, txtColor;

var private array<delegate<Fn_Canvas_Float_Float> > statDrawers;
var private int currentStat;

var KFPlayerController owner;

delegate Fn_Canvas_Float_Float(Canvas canvas, float x, float y);

function Initialized() {
    `Log("What is nextGroup? '" $ nextGroup $ "'");
    if (nextGroup == '') {
        nextGroup = 'F4';
        SaveConfig();
        `Log("Saving nextGroup default value");
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
    local delegate<Fn_Canvas_Float_Float> drawer;
    if (currentStat != -1) {
        drawer = statDrawers[currentStat];
        drawer(canvas, 0, owner.myHUD.SizeY / 2);
    }
}

private function drawWeaponStats(Canvas canvas, float x, float y) {
    local string text;
    local float width, height, x0, longest, highestKills, offset, widest;
    local EphemeralMatchStats.WeaponDamage it;

    canvas.Font= class'Engine'.static.GetSmallFont();

    longest = 0;
    highestKills = 0;
    widest = 0;
    foreach owner.MatchStats.WeaponDamageList(it) {
        text = it.WeaponDef.static.GetItemName();
        canvas.TextSize(text, width, height);
        offset = height;

        if (longest <= width) {
            longest = width;
        }

        canvas.TextSize(string(it.Kills), width, height);
        if (highestKills < width) {
            highestKills = width;
        }

        canvas.TextSize("(" $ it.HeadShots $ ")", width, height);
        if (widest < width) {
            widest = width;
        }
    }

    canvas.SetPos(x, y);
    canvas.SetDrawColorStruct(backgroundColor);
    canvas.DrawTileStretched(txtBackground, x + longest * 1.5 + highestKills * 1.5 + widest, 
            (owner.MatchStats.WeaponDamageList.length + 1) * height, 0, 0, 512, 512);

    text = "Weapons";
    canvas.SetPos(x, y);
    canvas.SetDrawColorStruct(txtColor);
    canvas.DrawText(text);

    x0 = x;
    foreach owner.MatchStats.WeaponDamageList(it) {
        y+= offset;
        text = it.WeaponDef.static.GetItemName();

        canvas.SetPos(x, y);
        canvas.DrawText(text);

        x = longest * 1.5;
        canvas.SetPos(x, y);
        canvas.DrawText(string(it.Kills));

        x += highestKills * 1.50;
        text = "(" $ it.HeadShots $ ")";
        canvas.SetPos(x, y);
        canvas.DrawText(text);

        x = x0;
    }

}

private function drawKillStats(Canvas canvas, float x, float y) {
    local string text;
    local float width, height, x0, longest, offset, widest;
    local EphemeralMatchStats.ZedKillType it;

    canvas.Font= class'Engine'.static.GetSmallFont();

    longest = 0;
    foreach owner.MatchStats.ZedKillsArray(it) {
        text = Localize("Zeds", String(it.MonsterClass.default.LocalizationKey), "KFGame");
        canvas.TextSize(text, width, height);
        offset = height;

        if (longest <= width) {
            longest = width;
        }

        canvas.TextSize(string(it.KillCount), width, height);
        if (widest < width) {
            widest = width;
        }
    }

    canvas.SetPos(x, y);
    canvas.SetDrawColorStruct(backgroundColor);
    canvas.DrawTileStretched(txtBackground, x + longest * 1.5 + widest, 
            (owner.MatchStats.ZedKillsArray.length + 1) * height, 0, 0, 512, 512);

    text = "Kills";
    canvas.SetPos(x, y);
    canvas.SetDrawColorStruct(txtColor);
    canvas.DrawText(text);

    x0 = x;
    foreach owner.MatchStats.ZedKillsArray(it) {
        y+= offset;
        text = Localize("Zeds", String(it.MonsterClass.default.LocalizationKey), "KFGame");

        canvas.SetPos(x, y);
        canvas.DrawText(text);

        x = longest * 1.5;
        canvas.SetPos(x, y);
        canvas.DrawText(string(it.KillCount));

        x = x0;
    }

}

private function drawPerkXP(Canvas canvas, float x, float y) {
    local string text;
    local float width, height, x0, longest, highestKills, offset, widest;
    local EphemeralMatchStats.PerkXPGain it;

    canvas.Font= class'Engine'.static.GetSmallFont();

    longest = 0;
    highestKills = 0;
    widest = 0;
    foreach owner.MatchStats.PerkXPList(it) {
        text = it.PerkClass.default.PerkName;
        canvas.TextSize(text, width, height);
        offset = height;

        if (longest <= width) {
            longest = width;
        }

        canvas.TextSize(string(it.XPDelta), width, height);
        if (highestKills < width) {
            highestKills = width;
        }

        canvas.TextSize("(" $ it.SecondaryXPGain $ ")", width, height);
        if (widest < width) {
            widest = width;
        }
    }

    canvas.SetPos(x, y);
    canvas.SetDrawColorStruct(backgroundColor);
    canvas.DrawTileStretched(txtBackground, x + longest * 1.5 + highestKills * 1.5 + widest, 
            (owner.MatchStats.PerkXPList.length + 1) * height, 0, 0, 512, 512);

    text = "Perks";
    canvas.SetPos(x, y);
    canvas.SetDrawColorStruct(txtColor);
    canvas.DrawText(text);

    x0 = x;
    foreach owner.MatchStats.PerkXPList(it) {
        y+= offset;
        text = it.PerkClass.default.PerkName;

        canvas.SetPos(x, y);
        canvas.DrawText(text);

        x = longest * 1.5;
        canvas.SetPos(x, y);
        canvas.DrawText(string(it.XPDelta));

        x += highestKills * 1.50;
        text = "(" $ it.SecondaryXPGain $ ")";
        canvas.SetPos(x, y);
        canvas.DrawText(text);

        x = x0;
    }
}

defaultproperties
{
    currentStat=-1

    txtColor=(R=0,G=255,B=0,A=255)
    backgroundColor=(R=255,G=255,B=255,A=127)
    txtBackground=Texture2D'Wep_1P_Shared_TEX.WEP_Detail_1_D'
    OnReceivedNativeInputKey=keyEvent

    statDrawers[0]=drawWeaponStats;
    statDrawers[1]=drawKillStats;
    statDrawers[2]=drawPerkXP;
}
