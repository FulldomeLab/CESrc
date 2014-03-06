class EHPawn extends GamePawn
	config(Game);

simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
	if (Controller == none)
		return Super.CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);

	out_CamLoc = Controller.Location;
	out_CamRot = Controller.Rotation;
	out_FOV = 90;

	return true;
}

defaultproperties
{
}
