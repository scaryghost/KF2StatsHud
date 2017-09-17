class Interaction extends Engine.Interaction
    config(Input);

var globalconfig name nextGroup;

var private bool showText;
var private Texture2D txtBackground;
var private Color backgroundColor, txtColor;

var KFPlayerController owner;

function bool keyEvent(int ControllerId, name Key, EInputEvent EventType, optional float AmountDepressed=1.f,
        optional bool bGamepad) {
    if (Key == nextGroup && EventType == IE_Pressed) {
        showText = !showText;
        return true;
    }
    return false;
}

event PostRender(Canvas canvas) {
    local string text;
    local float width, height, x, y, temp, longest, highestKills, offset;
    local EphemeralMatchStats.WeaponDamage it;

    if (showText) {
        x = 0;
        y = 0;

        text = "Hello World";
        canvas.Font= class'Engine'.static.GetSmallFont();
        canvas.TextSize(text, width, height);

        canvas.SetPos(x, y);
        canvas.SetDrawColorStruct(backgroundColor);        
        canvas.DrawTileStretched(txtBackground, width, height, 0, 0, width, height);

        canvas.SetPos(x, y);
        canvas.SetDrawColorStruct(txtColor);
        canvas.DrawText(text);

        longest = 0;
        highestKills = 0;
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
        }

        temp = x;
        foreach owner.MatchStats.WeaponDamageList(it) {
            y+= offset;
            text = it.WeaponDef.static.GetItemName();

            canvas.SetPos(x, y);
            canvas.DrawText(text);

            x = longest * 1.5;
            canvas.SetPos(x, y);
            canvas.DrawText(string(it.Kills));

            x += highestKills * 1.50;
            canvas.SetPos(x, y);
            canvas.DrawText("(" $ it.HeadShots $ ")");

            x = temp;
        }
    }
}

defaultproperties
{
    txtColor=(R=0,G=255,B=0,A=255)
    backgroundColor=(R=255,G=255,B=255,A=255)
    txtBackground=Texture2D'Wep_1P_Shared_TEX.WEP_Detail_1_D'
    OnReceivedNativeInputKey=keyEvent
}
