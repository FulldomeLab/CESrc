class CEHUD extends HUD;

// The texture which represents the cursor on the screen
var const Texture2D CursorTexture; 
// The color of the cursor
var const Color CursorColor;

simulated event PostBeginPlay()
{
  Super.PostBeginPlay();
}

simulated event Destroyed()
{
  Super.Destroyed();
}

function PreCalcValues()
{
  Super.PreCalcValues();
}

event PostRender(){
	 local float dx, dy;
	 local Texture2D t;
	 //local CelestialSphere celestialSphere;
	 local CEGameInfo g;

	 g = CEGameInfo(WorldInfo.Game);
	 if(g == none){
		 Super.PostRender();
		 return;
		}
	
	 if(g.SysState.BlackScreen){
		 Canvas.SetOrigin(0, 0);
		 Canvas.SetClip(Canvas.SizeX, Canvas.SizeY);
		 Canvas.SetPos(0, 0);
		 Canvas.DrawColor = Blackcolor;
		}
	 if(g.SysState.DrawGrid){
		 DrawGrid()
		}
	
	 Super.PostRender();
	}

function DrawGrid()
{
	local float x, y, xl, yl;

	Canvas.TextSize("000", xl, yl);
	for(x = -90; x < 90; x +=15)
	{
		Canvas.SetPos((x + 90 )* Canvas.SizeX / 180, 0);
		Canvas.DrawRect(2, Canvas.SizeY);
		Canvas.SetPos(2 + (x + 90 )* Canvas.SizeX / 180, 0);
		Canvas.DrawText(""$int(x), false);
		Canvas.SetPos(2 + (x + 90 )* Canvas.SizeX / 180, Canvas.SizeY - yl);
		Canvas.DrawText(""$int(x), false);
		Canvas.SetPos(2 + (x + 90 )* Canvas.SizeX / 180, Canvas.SizeY / 4);
		Canvas.DrawText(""$int(x), false);
		Canvas.SetPos(2 + (x + 90 )* Canvas.SizeX / 180, Canvas.SizeY / 2);
		Canvas.DrawText(""$int(x), false);
		Canvas.SetPos(2 + (x + 90 )* Canvas.SizeX / 180, Canvas.SizeY * 3 / 4);
		Canvas.DrawText(""$int(x), false);
	}
	x = 15 * Canvas.SizeX /180 - xl;
	for(y = 90; y > -90; y -=15)
	{
		Canvas.SetPos(0, (90 - y) * Canvas.SizeY / 180);
		Canvas.DrawRect(Canvas.SizeX, 2);
		Canvas.SetPos(x, (90 - y) * Canvas.SizeY / 180);
		Canvas.DrawText(""$int(y), false);
		Canvas.SetPos(Canvas.SizeX / 4 - xl, (90 - y) * Canvas.SizeY / 180);
		Canvas.DrawText(""$int(y), false);
		Canvas.SetPos(Canvas.SizeX / 2 - xl, (90 - y) * Canvas.SizeY / 180);
		Canvas.DrawText(""$int(y), false);
		Canvas.SetPos(Canvas.SizeX * 3 / 4 - xl, (90 - y) * Canvas.SizeY / 180);
		Canvas.DrawText(""$int(y), false);
		Canvas.SetPos(Canvas.SizeX - xl, (90 - y) * Canvas.SizeY / 180);
		Canvas.DrawText(""$int(y), false);
	}
	Canvas.SetPos(x, Canvas.SizeY - yl);
	Canvas.DrawText("-90", false);
	Canvas.SetPos(Canvas.SizeX / 4 - xl, Canvas.SizeY - yl);
	Canvas.DrawText("-90", false);
	Canvas.SetPos(Canvas.SizeX / 2 - xl, Canvas.SizeY - yl);
	Canvas.DrawText("-90", false);
	Canvas.SetPos(Canvas.SizeX * 3 / 4 - xl, Canvas.SizeY - yl);
	Canvas.DrawText("-90", false);
	Canvas.SetPos(Canvas.SizeX - xl, Canvas.SizeY - yl);
	Canvas.DrawText("-90", false);
}

function Vector GetMouseWorldLocation()
{
  local CEPlayerInput PInput;
  local Vector2D MousePosition;
  local Vector MouseWorldOrigin, MouseWorldDirection, HitLocation, HitNormal;

  // Ensure that we have a valid canvas and player owner
  if (Canvas == None || PlayerOwner == None)
  {
    return Vect(0, 0, 0);
  }

  // Type cast to get the new player input
  PInput = CEPlayerInput(PlayerOwner.PlayerInput);

  // Ensure that the player input is valid
  if (PInput == None)
  {
    return Vect(0, 0, 0);
  }

  // We stored the mouse position as an IntPoint, but it's needed as a Vector2D
  MousePosition.X = PInput.MousePosition.X;
  MousePosition.Y = PInput.MousePosition.Y;
  // Deproject the mouse position and store it in the cached vectors
  Canvas.DeProject(MousePosition, MouseWorldOrigin, MouseWorldDirection);

  // Perform a trace to get the actual mouse world location.
  Trace(HitLocation, HitNormal, MouseWorldOrigin + MouseWorldDirection * 65536.f, MouseWorldOrigin , true,,, TRACEFLAG_Bullet);
  return HitLocation;
}

defaultproperties
{
  CursorColor=(R=255,G=255,B=255,A=255)
  CursorTexture=Texture2D'EngineResources.Cursors.Arrow'
}