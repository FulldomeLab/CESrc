class MStack extends Object;

struct MStack_SandVal{
	 var() string Identifer;
	 var() bool Status;
	 var() float Number;
	 var() string Text;
	};
struct MStack_Action{
	 var() string Identifer;
	 //var transient bool Status;
	 var transient delegate<RunAct> Action;
	};
struct MStack_TimeVal{
	 var() string Identifer;
	 var() bool Status;
	 //var() float Number; // wtf?
	 var() float Wait;
	 var transient float CurWait;
	};
struct MStack_item{
	 var() string StackName;
	 var transient float JobTime, CurJobTime;
	 var transient array<MStack_SandVal> SandBox;
	 var transient array<MStack_TimeVal> TimeVals;
	 var transient array<MStack_Action> Actions;
	};

var transient array<MStack_item> Tickers;

delegate RunAct(string StackName, string Id, optional MStack_SandVal SandVal, optional MStack_TimeVal TimeVal, optional out int FreezStack);

static final preoperator int $ (out array<MStack_TimeVal> A){
	 return A.length-1;
	}
static final preoperator string ~ (out MStack_Action A){
	 return A.Identifer;
	}
static final preoperator string ~ (out MStack_SandVal A){
	 return A.Identifer;
	}
static final preoperator string ~ (out MStack_TimeVal A){
	 return A.Identifer;
	}
/*static final preoperator delegate<RunAct > $ (out MStack_Action A){
	 return A.Action;
	}*/
static final preoperator string $ (out MStack_SandVal A){
	 return A.Text;
	}
static final preoperator bool * (out MStack_Action A){
	 return A.Action == none;
	}
static final preoperator bool * (out MStack_SandVal A){
	 return $A == "";
	}
static final operator(22) MStack_Action >> (out MStack_Action A, string B){
	 A.Identifer = B;
	 return A;
	}
static final operator(22) MStack_SandVal >> (out MStack_SandVal A, string B){
	 A.Identifer = B;
	 return A;
	}
static final operator(22) MStack_TimeVal >> (out MStack_TimeVal A, string B){
	 A.Identifer = B;
	 return A;
	}
static final operator(22) MStack_Action << (out MStack_Action A, delegate<RunAct> B){
	 A.Action = B;
	 return A;
	}
static final operator(22) MStack_SandVal << (out MStack_SandVal A, string B){
	 A.Text = B;
	 return A;
	}
static final operator(22) MStack_SandVal << (out MStack_SandVal A, float B){
	 A.Number = B;
	 return A;
	}
static final operator(22) MStack_SandVal << (out MStack_SandVal A, bool B){
	 A.Status = B;
	 return A;
	}
static final operator(22) MStack_TimeVal << (out MStack_TimeVal A, float B){
	 A.Wait = B;
	 return A;
	}
static final operator(22) MStack_TimeVal << (out MStack_TimeVal A, string B){
	 if(B~="reset"){
		 A.CurWait = A.Wait;
		 A.Status = false;
		}else
	 if(B~="stop"){
		 A.CurWait = 0.0;
		 A.Status = false;
		}else
	 if(B~="runned"){
		 A.Status = true;
		}
	 return A;
	}
static final operator(24) bool == (out MStack_TimeVal A, string B){
	 if(B~="reset"){
		 return A.CurWait == A.Wait && !A.Status;
		}else
	 if(B~="stop"){
		 return A.CurWait == 0.0f && !A.Status;
		}else
	 if(B~="runned"){
		 return A.Status;
		}
	 return false;
	}
static final operator(24) bool ~= (MStack_Action A, string B){
	 return ~A ~= B;
	}

function int searchTick(string StackName){
	 return Tickers.Find('StackName', StackName);
	}
function int searchAction(MStack_item Q, string ActID){
	 return Q.Actions.Find('Identifer', ActID);
	}
function int searchSandVal(MStack_item Q, string ActID){
	 return Q.SandBox.Find('Identifer', ActID);
	}
function int searchTimeVal(MStack_item Q, string ActID){
	 return Q.TimeVals.Find('Identifer', ActID);
	}
function int create(string StackName){
	 local MStack_item Q;
	 Q.StackName = StackName;
	 Tickers.AddItem(Q);
	 return Tickers.Length-1;
	}
function delete(string StackName){
	 local int i;
	 i = searchTick(StackName);
	 if(i==INDEX_NONE) return;
	 Tickers.Remove(i, 1);
	}
function bool AddAction(string StackName, optional string ActId, optional delegate<RunAct> Action, optional MStack_Action Act){
	 local int i;
	 i = searchTick(StackName);
	 if(i==INDEX_NONE) return false;
	 if(ActId!="") Act>>ActId;
	 if(Action!=none) Act<<Action;
	 if(~Act==""||*Act) return false;
	 Tickers[i].Actions.AddItem(Act);
	 return true;
	}
function bool AddSandVal(string StackName, optional string SandId, optional string Text="", optional float Number=0.0f, optional bool Status=false, optional MStack_SandVal Val){
	 local int i;
	 i = searchTick(StackName);
	 if(i==INDEX_NONE) return false;
	 if(SandId!="") Val>>SandId;
	 if(Text!="") Val<<Text;
	 if(Number!=0.0f) Val<<Number;
	 if(Status) Val<<Status;
	 if(~Val=="") return false;
	 Tickers[i].SandBox.AddItem(Val);
	 return true;
	}
function bool AddTimeVal(string StackName, optional string Id, optional float Wait=0, optional MStack_TimeVal Val){
	 local int i;
	 i = searchTick(StackName);
	 if(i==INDEX_NONE) return false;
	 if(Id!="") Val>>Id;
	 if(Wait>0) Val<<Wait;
	 if(~Val=="") return false;
	 Tickers[i].TimeVals.AddItem(Val);
	 Tickers[i].TimeVals[$Tickers[i].TimeVals]<<"reset";
	 return true;
	}
function bool delTimeVal(string StackName, string Id){
	 local int i, q;
	 i = searchTick(StackName);
	 if(i==INDEX_NONE||Id=="") return false;
	 q = searchTimeVal(Tickers[i], ID);
	 if(q==INDEX_NONE) return false;
	 Tickers[i].TimeVals.Remove(q, 1);
	 return true;
	}
function bool delSandVal(string StackName, string Id){
	 local int i, q;
	 i = searchTick(StackName);
	 if(i==INDEX_NONE||Id=="") return false;
	 q = searchSandVal(Tickers[i], ID);
	 if(q==INDEX_NONE) return false;
	 Tickers[i].SandBox.Remove(q, 1);
	 return true;
	}
function bool delAction(string StackName, string Id){
	 local int i, q;
	 i = searchTick(StackName);
	 if(i==INDEX_NONE||Id=="") return false;
	 q = searchAction(Tickers[i], ID);
	 if(q==INDEX_NONE) return false;
	 Tickers[i].Actions.Remove(q, 1);
	 return true;
	}

function TickAll(float dt){
	 local MStack_item Q;
	 local MStack_TimeVal W;
	 local delegate<RunAct> On;
	 local int i, k, j, t, z;
	 foreach Tickers(Q, i){
		 foreach Q.TimeVals(W, k){
			 //k = Tickers[i].TimeVals.Find('Identifer', ~W); // Якщо із масива видаляти елементи, то слід перегружати номер
			 if(W.Status){
				 Tickers[i].CurJobTime+= dt;
				 Tickers[i].JobTime+= dt;
				 break;
				}
			 if(W.CurWait==0.0f) continue;
			 if(W.CurWait<=dt){
				 Tickers[i].CurJobTime = 0.0f;
				 Tickers[i].TimeVals[k].CurWait = 0.0f;
				 j = searchAction(Tickers[i], ~W);
				 if(j!=INDEX_NONE){
					 Tickers[i].TimeVals[k]<<"runned";
					 t = searchSandVal(Tickers[i], ~W);
					 On = Tickers[i].Actions[j].Action;
					 if(t!=INDEX_NONE){
						 On(Tickers[i].StackName, ~W, Tickers[i].SandBox[t], Tickers[i].TimeVals[k], z);
						 if(z>0)
							 Tickers[i].TimeVals[k].Status = true;
						}else{
						 On(Tickers[i].StackName, ~W, , Tickers[i].TimeVals[k], z);
						 if(z>0)
							 Tickers[i].TimeVals[k].Status = true;
						}
					}
				}else Tickers[i].TimeVals[k].CurWait-= dt;
			}
		}
	}
function bool check(string StackName){
	 local int i;
	 i = searchTick(StackName);
	 if(i==INDEX_NONE) return false;
	 return Tickers[i].CurJobTime>0;
	}
function bool checkTimeVal(string StackName, string ID){
	 local int i, q;
	 i = searchTick(StackName);
	 if(i==INDEX_NONE||ID=="") return false;
	 q = searchTimeVal(Tickers[i], ID);
	 if(q==INDEX_NONE) return false;
	 return !(Tickers[i].TimeVals[q]=="stop");
	}

defaultproperties
{
}
