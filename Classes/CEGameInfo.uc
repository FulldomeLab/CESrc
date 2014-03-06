class CEGameInfo extends GameInfo
	config(CE);

var transient CECamera fxc;
var transient CEPlayerController Pl;
var transient CEMapInfo MI;
var transient CEStatistic Stats;
var transient float ExecuteTime;

exec function chLang(optional name lang='def'){
	 local CelestialObject o;
	 switch(lang){
		 case 'UA':case 'ua': case 'ukr':
			 MI.LanguageState = CEL_UA;
			break;
		 case 'RU':case 'ru': case 'rus':
			 MI.LanguageState = CEL_RU;
			break;
		 case 'def':default:
			 MI.LanguageState = CEL_EN;
			break;
		}
	}

exec function ShowDebugInfo(optional float detailed=2){
	 `Log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	 `Log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	 `Log("Dump 'Debug Info':");
	 `Log(">GameState MI");
		
	 `Log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	 `Log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	}

event PreBeginPlay(){
	 RegisterPreGameStartEvent();
	}

event PostBeginPlay(){
	 local int i;
	 Super.PostBeginPlay();

	 RegisterPostGameStartEvent();
	
	 MI = CEMapInfo(WorldInfo.GetMapInfo());
	 Pl = CEPlayerController(GetALocalPlayerController());
	 if(Pl == none || MI == none) return;
	 fxc = CECamera(Pl.PlayerCamera);
	}

simulated event ShutDown(){
	 Super.ShutDown();
	}

event GameEnding(){
	 RegisterPreExitEvent();
	 Super.GameEnding();
	}

function BroadMsg(coerce string Msg, optional float LifeTime = 0.0){
	 local CEPlayerController P;
	 local PlayerReplicationInfo PRI;

	 foreach WorldInfo.AllControllers(class'CEPlayerController', P){
		 P.myHUD.AddConsoleMessage(Msg,class'LocalMessage',PRI,LifeTime);
		}
	}

event Tick(Float DeltaTime){
	 ExecuteTime+= DeltaTime;
	 Pl.GameTick(DeltaTime);
	}

exec function Fire(int WeaponIndex, array<Vector2D> pos){
	 fxc.Fire(WeaponIndex, pos);
	}

// ~~~ Statistics
function RegisterConsoleCommand(string command){
	 Stats.addFromConsoleCMD(command);
	 Stats.save(ExecuteTime);
	 ExecuteTime = 0;
	}
function RegisterPreGameStartEvent(){
	 Stats = new class'EHStatistic';
	 Stats.load();
	}
function RegisterPostGameStartEvent(){
	 ExecuteTime = 0.0f;
	}
function RegisterPreExitEvent(){
	 Stats.end(ExecuteTime);
	}

exec function myVersion(){
	 `Log("Earth Patrol - v3.0a build 1000 @2014");
	}

defaultproperties
{
	HUDType=class'EHGame.CEHUD'
	PlayerControllerClass=class'EHGame.CEPlayerController'
	DefaultPawnClass=class'EHGame.CEPawn'
	bDelayedStart=false
	bRestartLevel=false
	OnlineSub=none
	OnlineStatsWriteClass=none
}