class FCSceneCaptureActor extends SceneCapture2DActor
  ClassGroup(Common)
	placeable;

var transient float R, G, B;

function Tick(float dt){
	 Super.Tick(dt);
	 if(!bDebug) return;
	 DrawDebugLine(Location, Location+vector(Rotation) * 150, R, G, B);
	}

defaultproperties
{
 Components.Empty
 
 bHardAttach = True
 bStatic = False
 bNoDelete = False
 bDebug = false
 
 R = 250
 G = 250
 B = 0
}
