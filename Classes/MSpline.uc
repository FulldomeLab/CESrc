class MSpline extends Object;

struct MSpl_val{
	// Вектор (для побудови шляху)
	 var() vector outVec;
	// Поворот (для побудови орієнтації)
	 var() rotator outRot;
	// Число (для дистанція та інших можливостей)
	 var() float outFloat;
	// Перемикач (приймає значення ключа А і висить так всеь проміжок АВ)
	 var() bool outStateA;
	// Перемикач (приймає значення ключа на один кадр в момент наближення до ключа)
	 var() bool outStateB;
	 var   bool outStateB_;
	};
struct MSpl_item{
	 var() float inVal;
	 var() MSpl_val outVal;
	};
struct MSpl_Path{
	 var() string PName; // Назва шляху
	 var() array<MSpl_item> Points; // Опорні точки (ключі)
	 var transient int last;
	 var transient MSpl_val lastOut, Velocity;
	};

var array<MSpl_Path> Pathes;

static final operator(16) MSpl_val * (MSpl_val A, MSpl_val B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outVec		= A.outVec * B.outVec;
	 Res.outFloat	= A.outFloat * B.outFloat;
	 return Res;
	}
static final operator(16) MSpl_val / (MSpl_val A, MSpl_val B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outFloat	= A.outFloat / B.outFloat;
	 return Res;
	}
static final operator(16) MSpl_val * (MSpl_val A, float B){
	 local MSpl_val Res;
	 Res.outVec		= A.outVec * B;
	 Res.outRot		= A.outRot * B;
	 Res.outFloat	= A.outFloat * B;
	 return Res;
	}
static final operator(16) MSpl_val / (MSpl_val A, float B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outVec		= A.outVec / B;
	 Res.outRot		= A.outRot / B;
	 Res.outFloat	= A.outFloat / B;
	 return Res;
	}
static final operator(20) MSpl_val + (MSpl_val A, MSpl_val B){
	 local MSpl_val Res;
	 Res.outVec		= A.outVec + B.outVec;
	 Res.outRot		= A.outRot + B.outRot;
	 Res.outFloat	= A.outFloat + B.outFloat;
	 Res.outStateA	= A.outStateA || B.outStateA;
	 Res.outStateB	= A.outStateB && B.outStateB;
	 return Res;
	}
static final operator(20) MSpl_val - (MSpl_val A, MSpl_val B){
	 local MSpl_val Res;
	 Res.outVec		= A.outVec - B.outVec;
	 Res.outRot		= A.outRot - B.outRot;
	 Res.outFloat	= A.outFloat - B.outFloat;
	 Res.outStateA	= A.outStateA && !B.outStateA;
	 Res.outStateB	= A.outStateB || !B.outStateB;
	 return Res;
	}
static final operator(20) MSpl_val + (MSpl_val A, vector B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outVec+= B;
	 return Res;
	}
static final operator(20) MSpl_val - (MSpl_val A, vector B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outVec-= B;
	 return Res;
	}
static final operator(20) MSpl_val + (MSpl_val A, rotator B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outRot+= B;
	 return Res;
	}
static final operator(20) MSpl_val - (MSpl_val A, rotator B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outRot-= B;
	 return Res;
	}
static final operator(20) MSpl_val + (MSpl_val A, bool B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outStateA = B;
	 return Res;
	}
static final operator(20) MSpl_val - (MSpl_val A, bool B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outStateB = B;
	 return Res;
	}
static final operator(20) MSpl_val + (MSpl_val A, float B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outFloat+= B;
	 return Res;
	}
static final operator(20) MSpl_val - (MSpl_val A, float B){
	 local MSpl_val Res;
	 Res = A;
	 Res.outFloat-= B;
	 return Res;
	}
static final operator(34) MSpl_val += (out MSpl_val A, MSpl_val B){
	 A = A+B;
	 return A;
	}
static final operator(34) MSpl_val -= (out MSpl_val A, MSpl_val B){
	 A = A-B;
	 return A;
	}

static final operator(24) bool > (MSpl_item A, MSpl_item B){
	 return A.inVal>B.inVal;
	}
static final operator(24) bool < (MSpl_item A, MSpl_item B){
	 return A.inVal<B.inVal;
	}
static final operator(24) bool >= (MSpl_item A, MSpl_item B){
	 return A.inVal>=B.inVal;
	}
static final operator(24) bool <= (MSpl_item A, MSpl_item B){
	 return A.inVal<=B.inVal;
	}
static final operator(24) bool > (MSpl_item A, float B){
	 return A.inVal>B;
	}
static final operator(24) bool < (MSpl_item A, float B){
	 return A.inVal<B;
	}
static final operator(24) bool >= (MSpl_item A, float B){
	 return A.inVal>=B;
	}
static final operator(24) bool <= (MSpl_item A, float B){
	 return A.inVal<=B;
	}

static final preoperator int ~ (out MSpl_Path A){
	 return A.Points.Length;
	}
static final preoperator int ! (out MSpl_Path A){
	 return A.last;
	}
static final preoperator MSpl_item $ (out MSpl_Path A){
	 return A.Points[A.Points.Length-1];
	}
static final postoperator MSpl_val ! (out MSpl_Path A){
	 return A.lastOut;
	}
static final operator(34) MSpl_Path += (out MSpl_Path A, MSpl_item B){
	 A.Points.AddItem(B);
	 return A;
	}
static final operator(22) MSpl_Path << (out MSpl_Path A, float B){
	 MathPathAuto(B, A);
	 return A;
	}
static final operator(22) MSpl_item >> (MSpl_Path A, int B){
	 return A.Points[Clamp(B, 0, ~A)];
	}
static final operator(22) MSpl_item << (out MSpl_item A, Actor B){
	 A.outVal.outVec		= B.Location;
	 A.outVal.outRot		= B.Rotation;
	 return A;
	}

static function MSpl_item ItemFromActor(float inVal, Actor A, optional float Fl, optional bool bA, optional bool bB){
	 local MSpl_item Res;
	 Res.inVal = inVal;
	 Res.outVal.outVec		= A.Location;
	 Res.outVal.outRot		= A.Rotation;
	 Res.outVal.outFloat		= Fl;
	 Res.outVal.outStateA	= bA;
	 Res.outVal.outStateB	= bB;
	 return Res;
	}
static function MSpl_item ItemFromVals(float inVal, vector oVec, rotator oRot, optional float Fl, optional bool bA, optional bool bB){
	 local MSpl_item Res;
	 Res.inVal = inVal;
	 Res.outVal.outVec		= oVec;
	 Res.outVal.outRot		= oRot;
	 Res.outVal.outFloat		= Fl;
	 Res.outVal.outStateA	= bA;
	 Res.outVal.outStateB	= bB;
	 return Res;
	}

static function MSpl_val MathABLerpBool(MSpl_val A, MSpl_val B, float prg, out MSpl_val Res){
	 Res.outStateA = (prg>0.999)?B.outStateA:A.outStateA;
	 if(A.outStateB&&prg<0.5){
		 if(!Res.outStateB_){
			 Res.outStateB = true;
			 Res.outStateB_ = true;
			}else Res.outStateB = false;
		}else Res.outStateB_ = false;
	 return Res;
	}
static function MSpl_val MathABLerp(MSpl_val A, MSpl_val B, float prg, out MSpl_val Res){
	 Res.outVec = VLerp(A.outVec, B.outVec, prg);
	 Res.outRot = RLerp(A.outRot, B.outRot, prg, true);
	 MathABLerpBool(A, B, prg, Res);
	 return Res;
	}
static function MSpl_val MathABLerpCurveErmit(MSpl_val A, MSpl_val B, float prg, out MSpl_val Res){
	 local vector m0, m1;
	 m0 = vector(A.outRot)*400;
	 m1 = vector(B.outRot)*400;  
	 //m0 = vector(A.outRot)*FClamp(VSize(Res.outVec), 1, 1000)*10;
	 //m1 = vector(B.outRot)*FClamp(VSize(Res.outVec), 50, 1000);
	 Res.outVec = (1-prg)**2*(1+2*prg)*A.outVec + prg*(1-prg)**2*m0+prg**2*(3-2*prg)*B.outVec + prg**2*(prg-1)*m1;
	 //Res.outRot = QuatToRotator(QuatSlerp(QuatFromRotator(A.outRot), QuatFromRotator(B.outRot), class'MAnimations'.static.easeIn(prg, MAniDelta_smooth)));
	 Res.outRot = QuatToRotator(QuatSlerp(QuatFromRotator(A.outRot), QuatFromRotator(B.outRot), prg));
	 MathABLerpBool(A, B, prg, Res);
	 return Res;
	}
static function MSpl_val MathPathAuto(float prg, out MSpl_Path CurPath){
	 local int i, w;
	 local MSpl_val temp;
	 w = ~CurPath;
	 if(w==1){
		 return CurPath.Points[0].outVal;
		}else if(w==0) return temp;
	 i = !CurPath;
	 if(i==w){
		 CurPath.last = i;
		 CurPath.Velocity = temp;
		 return CurPath.Points[i-1].outVal;
		}else if(prg<0) prg = 0;
	 while(i<w){
		 if(CurPath.Points[i]>prg) break;
		 i++;
		}
	 if(i==w){
		 CurPath.last = i;
		 CurPath.Velocity = temp;
		 return CurPath.Points[i-1].outVal;
		}
	 //temp = MathABLerpCurveErmit(CurPath.Points[i-1].outVal, CurPath.Points[i].outVal, (prg-CurPath.Points[i-1].inVal)/(CurPath.Points[i].inVal-CurPath.Points[i-1].inVal), CurPath.Velocity);
	 temp = MathABLerp(CurPath.Points[i-1].outVal, CurPath.Points[i].outVal, (prg-CurPath.Points[i-1].inVal)/(CurPath.Points[i].inVal-CurPath.Points[i-1].inVal), CurPath.Velocity);
	 CurPath.Velocity = temp - CurPath.lastOut;
	 if(CurPath.Velocity.outVec==temp.outVec){
		 CurPath.Velocity = temp - CurPath.Points[i-1].outVal;
		}
	 CurPath.lastOut = temp;
	 CurPath.last = i;
	 return CurPath.lastOut;
	}

static function MSpl_Path makePatch(MSpl_item item){
	 local MSpl_Path P;
	 P+= item;
	 return P;
	}
static function MSpl_Path makePatchFromActors(array<Actor> Points, optional float TimeStep = 1.0){
	 local MSpl_Path Q;
	 addPointsFromActors(Q, Points, TimeStep);
	 return Q;
	}
static function float addPointsFromActors(out MSpl_Path Q, array<Actor> Points, optional float TimeStep = 1.0){
	 local MSpl_item Z;
	 local Actor A;
	 local float Val;
	 Val = ($Q).inVal;
	 foreach Points(A){
		 if(MTimePointKey(A)!=none)
			 Val = Val+MTimePointKey(A).TimeTo;
			else Val+= TimeStep;
		 Z.inVal = Val;
		 Q+= Z<<A;
		}
	 return ($Q).inVal;
	}
static function MSpl_Path reset(out MSpl_Path Q){
	 local MSpl_val lastOut, Velocity;
	 Q.last = 0;
	 Q.Velocity = Velocity;
	 Q.lastOut = lastOut;
	 return Q;
	}

/* ~~ Instruction
var() MAni_Info Animation;
var transient MAnimations MAni;

var() StaticMeshComponent AComponent;
var() array<Actor> Points;
var transient MSpline MSpl;
var transient MSpl_Path Q;

event PostBeginPlay(){
	 Super.PostBeginPlay();
	 Animation.EndTime = class'MSpline'.static.addPointsFromActors(Q, Points, 1.2);
	 MAni = new class'MAnimations';
	 MAni.Stack("test", Animation);
	 MAni.AddActor("test", self);
	 MAni.AddActionStep("test", AniTick);
	 MAni.AddActionStart("test", AniStart);
	}

simulated function Tick(float dt){
	 Super.Tick(dt);
	 MAni.StepAll(dt);
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
*/

defaultproperties
{	
}
