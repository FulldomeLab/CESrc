class CEStatistic extends Object
	Config(CEStatistic);

struct FunStat{
	 var() string Fun;
	 //var() string Args;
	 var() int Counts;
	};

var globalconfig array<FunStat> Functions;
var globalconfig FunStat LastFun;
var globalconfig float GlobalWorkTime;
var globalconfig int SessionsCount;
var globalconfig int SessionsCrashed;
var globalconfig int LastSended;

//dllimport final function int sendMessage(string Mess);

function save(optional float time=-1){
	 if(time>0) GlobalWorkTime+= time;
	 SaveConfig();
	}

function end(optional float time=-1){
	 LastFun.Fun = "exit";
	 LastFun.Counts = 1;
	 save(time);
	}

function int sendDebugToMe(){
	 local FunStat Q;
	 local string msg;
	 msg = "EH Statistics\r\n\r\nFunctions list\r\n";
	 foreach Functions(Q){
		 msg = msg$"\r\n>>>"@Q.Fun@Q.Counts;
		}
	 msg = msg$"\r\n\r\nGlobal work time:"@GlobalWorkTime;
	 msg = msg$"\r\nSessions count:"@SessionsCount;
	 msg = msg$"\r\n- crashed:"@SessionsCrashed;
	 
	 //return sendMessage(msg);
	 return -1;
	}

function load(){
	 if((SessionsCount-LastSended)>50){
		 LastSended = SessionsCount;
		 `Log("Send statistic!"@sendDebugToMe());
		}
	 SessionsCount++;
	 if(LastFun.Fun!=""&&LastFun.Fun!="exit") SessionsCrashed++;
	}

function addFromConsoleCMD(string cmd){
	 //local FunStat Fun;
	 local int q;
	 q = InStr(cmd, " ");
	 if(q>0) cmd = Left(cmd, q);
	 cmd = Locs(cmd);
	 if(LastFun.Fun == cmd){
		 LastFun.Counts+= 1;
		}else{
		 LastFun.Fun = cmd;
		 LastFun.Counts = 1;
		}
	 q = Functions.Find('Fun', cmd);
	 if(q==INDEX_NONE){
		 Functions.AddItem(LastFun);
		}else{
		 Functions[q].Counts+= 1;
		}
	}

defaultproperties
{
}