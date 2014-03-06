class MTick extends Object;

struct MTick_TimeItem{
	 var() float Wait;
	 var transient delegate<OnTick> Action;
	};
struct MTick_item{
	 var() string TName;
	 var transient array<MTick_TimeItem> Waits;
	 var transient array<delegate<OnTick> > Actions;
	};

var transient array<MTick_item> Tickers;

delegate OnTick(float p);

function int searchTick(string TName){
	 return Tickers.Find('TName', TName);
	}
function int create(string TName){
	 local MTick_item Q;
	 Q.TName = TName;
	 Tickers.AddItem(Q);
	 return Tickers.Length-1;
	}
function delete(string TName){
	 local int i;
	 i = searchTick(TName);
	 if(i==INDEX_NONE) return;
	 Tickers.Remove(i, 1);
	}
function AddAction(string TName, delegate<OnTick> Act){
	 local int i;
	 i = searchTick(TName);
	 if(i==INDEX_NONE) return;
	 Tickers[i].Actions.AddItem(Act);
	}
function AddWait(string TName, float Wait, delegate<OnTick> Act){
	 local MTick_TimeItem W;
	 local int i;
	 i = searchTick(TName);
	 if(i==INDEX_NONE) return;
	 W.Wait = Wait;
	 W.Action = Act;
	 Tickers[i].Waits.AddItem(W);
	}

function TickAll(float dt){
	 local MTick_item Q;
	 local MTick_TimeItem W;
	 local delegate<OnTick> On;
	 local int i, k;
	 foreach Tickers(Q, i){
		 foreach Q.Actions(On){
			 On(dt);
			}
		 foreach Q.Waits(W){
			 W.Wait-= dt;
			 k = Tickers[i].Waits.Find('Action', W.Action);
			 if(W.Wait<=0){
				 On = W.Action;
				 On(dt);
				 Tickers[i].Waits.Remove(k, 1);
				}else{
				 Tickers[i].Waits[k].Wait = W.Wait;
				}
			}
		}
	}
function bool check(string TName){
	 local int i;
	 i = searchTick(TName);
	 if(i==INDEX_NONE) return false;
	 return Tickers[i].Actions.Length>0;
	}

/* ~~ Instruction
var() MAni_Info Animation;
var() MAni_Info Animation2;
var transient MAnimations MAni;

var() StaticMeshComponent AComponent;
var() array<Actor> Points;
var transient MSpline MSpl;
var transient MSpl_Path Q;
var transient MTick TK;

event PreBeginPlay(){
	 Super.PreBeginPlay();
	 Animation.EndTime = class'MSpline'.static.addPointsFromActors(Q, Points, 1.2);
	 
	 MAni = new class'MAnimations';
	 MAni.Stack("move", Animation);
	 MAni.AddActor("move", self);
	 MAni.AddActionStep("move", AniTick);
	 MAni.AddActionStart("move", AniStart);
	 MAni.Stack("scale", Animation2);
	 MAni.AddActor("scale", self);
	 MAni.AddActionStep("scale", AniTick2);
	 MAni.AddActionStart("scale", AniStart2);
	 MAni.AddActionEnd("scale", EndScaleOut);
	 MAni.Stack("scale2", Animation2);
	 MAni.AddActor("scale2", self);
	 MAni.AddActionStep("scale2", AniTick3);
	 MAni.AddActionStart("scale2", AniStart3);
	 MAni.AddActionEnd("scale2", EndScaleIn);
	 
	 TK = new class'MTick';
	 TK.create("this");
	 TK.AddAction("this", MyTick);
	 TK.AddWait("this", 2.0, RunScaleOut);
	}

simulated function Tick(float dt){
	 TK.TickAll(dt);
	}
simulated function MyTick(float dt){
	 MAni.Step("move", dt);
	}
simulated function RunScaleOut(float dt){
	 TK.create("scaleOut");
	 TK.AddAction("scaleOut", ScaleOutTick);
	}
simulated function ScaleOutTick(float dt){
	 MAni.Step("scale", dt);
	}
simulated function EndScaleOut(MAni_list_item current){
	 TK.delete("scaleOut");
	 TK.AddWait("this", 2.0, RunScaleIn);
	 MAni.reset("scale");
	}
simulated function RunScaleIn(float dt){
	 TK.create("scaleIn");
	 TK.AddAction("scaleIn", ScaleInTick);
	}
simulated function ScaleInTick(float dt){
	 MAni.Step("scale2", dt);
	}
simulated function EndScaleIn(MAni_list_item current){
	 TK.delete("scaleIn");
	 TK.AddWait("this", 2.0, RunScaleOut);
	 MAni.reset("scale2");
	}
function AniStart(MAni_list_item current){
	 class'MSpline'.static.reset(Q);
	}
function AniTick(float p, MAni_list_item current){
	 local MSpl_val PVal;
	 local float prg;
	 prg = p*Animation.EndTime;
	 PVal = class'MSpline'.static.MathPathAuto(prg, Q);
	 setLocation(PVal.outVec);
	 setRotation(PVal.outRot);
	}
function AniStart2(MAni_list_item current){
	 setDrawScale(1.01);
	}
function AniTick2(float p, MAni_list_item current){
	 setDrawScale(1-p+0.01);
	}
function AniStart3(MAni_list_item current){
	 setDrawScale(0.01);
	}
function AniTick3(float p, MAni_list_item current){
	 setDrawScale(p+0.01);
	}

*/

defaultproperties
{	
}
