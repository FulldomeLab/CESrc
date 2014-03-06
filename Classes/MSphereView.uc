class MSphereView extends Object;

struct MSView_settings{
	 var() Actor Target; // Об'єкт у фокусі
	 var() Actor Mover; // Об'єкт, який слід переміщати
	 var() bool GetInFocus; // Тримати об'єкт у фокусі (автоповорот)
	 var() float Distance ;// Відстань спостереження
	 var() float minAlpha; // Мінімальний можливий кут при обертанні (по осі x)
	 var() float maxAlpha; // Максимальний можливий кут при обертанні (по осі x)
	 var() float minBeta; // Мінімальний можливий кут при обертанні (по осі y)
	 var() float maxBeta; // Максимальний можливий кут при обертанні (по осі y)
	 
	 var() bool invRot;
	
	 var transient float a;
	 var transient float b;
	};

final static function vector getPos(float alpha, float beta, optional float distance = 1.0f){
	 local rotator R;
	 R.yaw	= alpha * DegToUnrRot;
	 R.pitch	= beta * DegToUnrRot;
	 return vector(R) * distance;
	}

final static function vector getPosWithSett(MSView_settings Sett){
	 return getPos(FClamp(Sett.a, Sett.minAlpha, Sett.maxAlpha), FClamp(Sett.b, Sett.minBeta, Sett.maxBeta), Sett.Distance);
	}

final static function chAngle(out MSView_settings Sett, optional float chA = 0, optional float chB = 0){
	 local float nA, nB;
	 nA = Sett.a+chA;
	 if(nA>360||nA<-360)
		 nA-= int(nA/360.0f) * 360.0f;
	 nA = FClamp(nA, Sett.minAlpha, Sett.maxAlpha);
	 Sett.a = nA;
	 nB = Sett.b+chB;
	 if(nB>360||nB<-360)
		 nB-= int(nB/360.0f) * 360.0f;
	 nB = FClamp(nB, Sett.minBeta, Sett.maxBeta);
	 Sett.b = nB;
	}

final static function applyPosWithSett(out MSView_settings Sett, optional float chA = 0, optional float chB = 0){
	 local vector P;
	 chAngle(Sett, chA, chB);
	 P = getPos(Sett.a, Sett.b, Sett.Distance);
	 if(Sett.Target!=none){
		 P = Sett.Target.Location + P;
		}
	 if(Sett.Mover!=none){
		 Sett.Mover.setLocation(P);
		 `Log("applyPosWithSett"@P@Sett.Mover.Location);
		 if(Sett.GetInFocus&&Sett.Target!=none){
			 if(Sett.invRot)
				 Sett.Mover.setRotation(rotator(P - Sett.Target.Location));
				else
				 Sett.Mover.setRotation(rotator(Sett.Target.Location - P));
			}
		}
	}

defaultproperties
{
}
