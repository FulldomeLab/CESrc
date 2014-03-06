class MAnimations extends Object;

enum MAni_delta{
	MAniDelta_linear,
	MAniDelta_pow2,
	MAniDelta_pow5,
	MAniDelta_circ,
	MAniDelta_back,
	MAniDelta_bounce,
	MAniDelta_elastic,
	MAniDelta_smooth,
	MAniDelta_smooth1,
	MAniDelta_smooth2,
};
enum MAni_deltaEase{
	MAniDt_easeIn,
	MAniDt_easeOut,
	MAniDt_easeInOut,
};
struct MAni_Info{
	var float CurTime;
	var() float EndTime; // Час анімації
	var bool Started;
	var() bool bLoop; // Зациклити?
	var() MAni_delta Delta; // Формула анімації
	var() MAni_deltaEase Type; // Тип анімації
};

struct MAni_list_item{
	 var() string AName;
	 var() MAni_Info Animation;
	 var transient array<Actor> Actors;
	 var transient array<delegate<OnStart> > StartActions;
	 var transient array<delegate<OnStep> > StepActions;
	 var transient array<delegate<OnEnd> > EndActions;
	};

var transient array<MAni_list_item> Animations;

delegate OnStart(MAni_list_item current);
delegate OnStep(float p, MAni_list_item current);
delegate OnEnd(MAni_list_item current);

static function float Bounce(float progress){
	 local float a, b;
	 a = 0;
	 b = 1;
	 while(true){
		 if(progress>=((7-4*a)/11)) return -(((11-6*a-11*progress)/4)**2) + b**2;
		 a+=b;
		 b/=2;
		}
	 return 1.0;
	}
static function float Elastic(float progress, optional float x=1.5){	 
	 return (2**(10 * (progress - 1))) * cos(20 * progress * PI * x/3);
	}

static function float easeIn(float p, MAni_delta DtType, optional float x=1.5){
	 switch(DtType){
		 case MAniDelta_pow2:
			 return p**2;
			break;
		 case MAniDelta_pow5:
			 return p**5;
			break;
		 case MAniDelta_circ:
			 return 1-sin(acos(p));
			break;
		 case MAniDelta_back:
			 return (p**2)*((x+1)*p-x);
			break;
		 case MAniDelta_bounce:
			 return Bounce(p);
			break;
		 case MAniDelta_elastic:
			 return Elastic(p, x);
			break;
		 case MAniDelta_smooth:
			 return (p*p*(3-2*p));
			break;
		 case MAniDelta_smooth1:
			 return (sin((p)*PI/2))**2;
			break;
		 case MAniDelta_smooth2:
			 return (sin(((sin((p)*PI/2))**2)*PI/2))**2;
			break;
		 default:
			 return p;
		}
	}
static function float easeOut(float p, MAni_delta DtType, optional float x=1.5){
	 return 1 - easeIn(1 - p, DtType);
	}
static function float easeInOut(float p, MAni_delta DtType, optional float x=1.5){
	 if(p<=0.5) return easeIn(2 * p, DtType) / 2;
	 return (2 - easeIn(2 * (1 - p), DtType)) / 2;
	}

static function float Math(MAni_Info Animation, optional float x=1.5){
	 local float p;
	 p = FClamp(Animation.CurTime / Animation.EndTime, 0, 1);
	 switch(Animation.Type){
		 case MAniDt_easeOut:
			 p = easeOut(p, Animation.Delta, x);
			break;
		 case MAniDt_easeInOut:
			 p = easeInOut(p, Animation.Delta, x);
			break;
		 default:
			 p = easeIn(p, Animation.Delta, x);
		}
	 return p;
	}
static function float DtMath(float dt, out MAni_Info Animation, optional float x=1.5){
	 Animation.CurTime = FClamp(Animation.CurTime+dt, 0, Animation.EndTime);
	 return Math(Animation, x);
	}

static function MAni_Info create(float AniTime, optional MAni_delta Delta, optional MAni_deltaEase Type){
	 local MAni_Info Q;
	 Q.CurTime = 0;
	 Q.EndTime = AniTime;
	 Q.Delta = Delta;
	 Q.Type = Type;
	 return Q;
	}

function int searchAni(string AName){
	 return Animations.Find('AName', AName);
	}
function int Stack(string AName, MAni_Info Animation, optional array<Actor> Actors){
	 local MAni_list_item Q;
	 Q.AName = AName;
	 Q.Animation = Animation;
	 Q.Actors = Actors;
	 Animations.AddItem(Q);
	 return Animations.Length-1;
	}
function AddActor(string AName, Actor A){
	 local int i;
	 i = searchAni(AName);
	 if(i==INDEX_NONE) return;
	 Animations[i].Actors.AddItem(A);
	}
static function resetAni(out MAni_Info Animation){
	 Animation.CurTime = 0;
	}
function reset(string AName, optional float duration=-1){
	 local int i;
	 local MAni_Info Q;
	 i = searchAni(AName);
	 if(i==INDEX_NONE) return;
	 Q = Animations[i].Animation;
	 resetAni(Q);
	 if(duration>0) Q.EndTime = duration;
	 Animations[i].Animation = Q;
	 //Animations[i].Animation.curTime = 0;
	}
function endAni(string AName){
	 local int i;
	 i = searchAni(AName);
	 if(i==INDEX_NONE) return;
	 Animations[i].Animation.curTime = Animations[i].Animation.EndTime;
	 Animations[i].Animation.Started = false;
	}
function resetAll(){
	 local MAni_list_item Q;
	 local int i;
	 foreach Animations(Q, i){
		 resetAni(Q.Animation);
		 Animations[i].Animation = Q.Animation;
		}
	}

function StepAll(float dt){
	 local MAni_list_item Q;
	 local int i;
	 local delegate<OnStart> StartAction;
	 local delegate<OnStep> StepAction;
	 local delegate<OnEnd>  EndAction;
	 local float p;
	 foreach Animations(Q, i){
		 p = DtMath(dt, Q.Animation);
		 if(!Q.Animation.Started){
			 if(p==1) continue;
			 foreach Q.StartActions(StartAction){
				 StartAction(Q);
				}
			}else if(p==1){
			 foreach Q.StepActions(StepAction){
				 StepAction(1, Q);
				}
			 foreach Q.EndActions(EndAction){
				 EndAction(Q);
				}
			 if(Q.Animation.bLoop){
				 resetAni(Q.Animation);
				}
			 Q.Animation.Started = false;
			 Animations[i].Animation = Q.Animation;
			 continue;
			}
		 foreach Q.StepActions(StepAction){
			 StepAction(p, Q);
			}
		 Q.Animation.Started = true;
		 Animations[i].Animation = Q.Animation;
		}
	}
function Step(string AName, float dt){
	 local MAni_list_item Q;
	 local int i;
	 local delegate<OnStart> StartAction;
	 local delegate<OnStep> StepAction;
	 local delegate<OnEnd>  EndAction;
	 local float p;
	 i = searchAni(AName);
	 if(i==INDEX_NONE) return;
	 Q = Animations[i];
	 p = DtMath(dt, Q.Animation);
	 if(!Q.Animation.Started){
		 if(p==1) return;
		 foreach Q.StartActions(StartAction){
			 StartAction(Q);
			}
		}else if(p==1){
		 foreach Q.StepActions(StepAction){
			 StepAction(1, Q);
			}
		 foreach Q.EndActions(EndAction){
			 EndAction(Q);
			}
		 if(Q.Animation.bLoop){
			 resetAni(Q.Animation);
			}
		 Q.Animation.Started = false;
		 Animations[i].Animation = Q.Animation;
		 return;
		}
	 foreach Q.StepActions(StepAction){
		 StepAction(p, Q);
		}
	 Q.Animation.Started = true;
	 Animations[i].Animation = Q.Animation;
	}
function bool check(string AName){
	 local int i;
	 i = searchAni(AName);
	 if(i==INDEX_NONE) return false;
	 if(Animations[i].Animation.CurTime>=Animations[i].Animation.EndTime) return false;
		else return true;
	}
function bool is(string AName){
	 local int i;
	 i = searchAni(AName);
	 if(i==INDEX_NONE) return false;
	 return true;
	}

function AddActionStart(string AName, delegate<OnStart> Action){
	 local int i;
	 i = searchAni(AName);
	 if(i==INDEX_NONE) return;
	 Animations[i].StartActions.AddItem(Action);
	}
function AddActionStep(string AName, delegate<OnStep> Action){
	 local int i;
	 i = searchAni(AName);
	 if(i==INDEX_NONE) return;
	 Animations[i].StepActions.AddItem(Action);
	}
function AddActionEnd(string AName, delegate<OnEnd> Action){
	 local int i;
	 i = searchAni(AName);
	 if(i==INDEX_NONE) return;
	 Animations[i].EndActions.AddItem(Action);
	}

/* ~~ Instruction
var() MAni_Info Animation;
var transient MAnimations MAni;

var() StaticMeshComponent AComponent;
var() Actor EndPos;
var transient vector StartPos;

event PostBeginPlay(){
	 Super.PostBeginPlay();
	 MAni = new class'MAnimations';
	 MAni.Stack("test", Animation);
	 MAni.AddActor("test", self);
	 MAni.AddActionStep("test", AniTick);
	 StartPos = Location;
	}

simulated function Tick(float dt){
	 Super.Tick(dt);
	 MAni.StepAll(dt);
	}
function AniTick(float p, MAni_list_item current){
	 setLocation(VLerp(StartPos, EndPos.Location, p));
	}
*/

defaultproperties
{	
}