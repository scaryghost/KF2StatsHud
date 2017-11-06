class Overlay extends Object;

var private Texture2D txtBackground;
var private Color backgroundColor, txtColor;

var string title;
var delegate<FnString_KFPC_Int> getPrimaryValue, getSecondaryValue, getItemName;
var delegate<FnInt_KFPC> getLength;

delegate string FnString_KFPC_Int(KFPlayerController controller, int i);
delegate int FnInt_KFPC(KFPlayerController controller);

function draw(KFPlayerController controller, Canvas canvas, float x, float y) {
    local string text;
    local float width, height, x0, longest, highestKills, offset, widest;
    local int i;

    canvas.Font= class'Engine'.static.GetSmallFont();

    longest = 0;
    highestKills = 0;
    widest = 0;
    for(i = 0; i < getLength(controller); i++) {
        text = getItemName(controller, i);
        canvas.TextSize(text, width, height);
        offset = height;

        if (longest <= width) {
            longest = width;
        }

        canvas.TextSize(getPrimaryValue(controller, i), width, height);
        if (highestKills < width) {
            highestKills = width;
        }

        text = getSecondaryValue(controller, i);
        if (Len(text) != 0) {
            canvas.TextSize("(" $ text $ ")", width, height);
            if (widest < width) {
                widest = width;
            }
        }
    }

    canvas.SetPos(x, y);
    canvas.SetDrawColorStruct(backgroundColor);
    canvas.DrawTileStretched(txtBackground, x + longest * 1.5 + highestKills * 1.5 + widest, 
            (getLength(controller) + 1) * height, 0, 0, 512, 512);

    text = title;
    canvas.SetPos(x, y);
    canvas.SetDrawColorStruct(txtColor);
    canvas.DrawText(text);

    x0 = x;
    for(i = 0; i < getLength(controller); i++) {
        y+= offset;
        text = getItemName(controller, i);

        canvas.SetPos(x, y);
        canvas.DrawText(text);

        x = longest * 1.5;
        canvas.SetPos(x, y);
        canvas.DrawText(getPrimaryValue(controller, i));

        text = getSecondaryValue(controller, i);
        if (Len(text) != 0) {
            x += highestKills * 1.50;
            text = "(" $ text $ ")";
            canvas.SetPos(x, y);
            canvas.DrawText(text);
        }

        x = x0;
    }
}

defaultproperties
{
    txtColor=(R=0,G=255,B=0,A=255)
    backgroundColor=(R=255,G=255,B=255,A=127)
    txtBackground=Texture2D'Wep_1P_Shared_TEX.WEP_Detail_1_D'
}
