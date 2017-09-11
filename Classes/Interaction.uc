class Interaction extends Engine.Interaction
    config(Input);

var globalconfig name nextGroup;

var private bool showText;

function bool keyEvent(int ControllerId, name Key, EInputEvent EventType, optional float AmountDepressed=1.f,
        optional bool bGamepad) {
    if (Key == nextGroup && EventType == IE_Pressed) {
        showText = !showText;
        return true;
    }
    return false;
}

event PostRender(Canvas canvas) {
    if (showText) {
        canvas.Font= class'Engine'.static.GetSmallFont();
        canvas.SetPos(0, 0);
        canvas.DrawText("Hello World");
    }
}

defaultproperties
{
    OnReceivedNativeInputKey=keyEvent
}
