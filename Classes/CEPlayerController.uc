class CEPlayerController extends PlayerController //GamePlayerController
	config(Game)
	DLLBind(EHOSC);

const CelestialMarkDistance = 30000;

var transient CECamera fxc; // Cache camera reference
var transient bool bWeaponDisabled;

struct PCUpdateData
{
	var string Command;
	var array<int> PropertyChanged;
	var array<float> Hits;
	var string Info;
};
var transient PCUpdateData OSCServerData;
replication
{
    if(Role==ROLE_Authority && (bNetDirty || bNetInitial))
        BBS;
}

dllimport final function bool CEPlayerController_GetUpdateData(out PCUpdateData Data);
dllimport final function StartServer(int Port);

simulated event PostBeginPlay(){
	 local ViewSphere vs;

	 WorldInfo.WorldGravityZ = 0;
	 WorldInfo.GlobalGravityZ = 0;
	 Super.PostBeginPlay();
	
	 fxc = CECamera(PlayerCamera);
	}

exec function OSCServer(int port){
	 StartServer(port);
	}

exec function CEPause(optional bool bPause = true){
	 if(bPause == IsPaused())
		return;
	 SetPause(bPause);
	}

function OSCUpdate(){
	 local array<Vector2D> Hits; 
	 local int i;

	 OSCServerData.Hits.Length = 100;

	 if(!CEPlayerController_GetUpdateData(OSCServerData)){
		 return;
		}

	 `Dlog(OSCServerData.Info);

	 if(Len(OSCServerData.Command) > 0){
		 `Dlog("ConsoleCommand " $ OSCServerData.Command);
		 ConsoleCommand(OSCServerData.Command);
		}

	 if(OSCServerData.Hits.Length > 0){
		 Hits.Length = OSCServerData.Hits.Length / 2;
		 `Dlog("Hits " $ OSCServerData.Hits.Length $ " -> " $ Hits.Length);
		 for(i = 0; i < Hits.Length; ++i){
			 Hits[i].X = OSCServerData.Hits[i << 1];
			 Hits[i].Y = OSCServerData.Hits[(i << 1) + 1];
			}
		 if(bWeaponDisabled) continue;
		 CEGameInfo(WorldInfo.Game).Fire(Hits);
		}
	}

exec function EnableWeapon(){
	 bWeaponDisabled = false;
	}
exec function DisableWeapon(){
	 bWeaponDisabled = true;
	}

function PlayerTick(float dt){
	 Super.PlayerTick(dt);
	 if(fxc!=none) fxc.PlayerTick(dt);
	}
function GameTick(float dt){
	 
	}

defaultproperties
{
	InputClass=class'CEPlayerInput'
	CameraClass=class'CECamera'
	bGodMode=true
	bCollideWhenPlacing=false
	bGameRelevant = true
}
