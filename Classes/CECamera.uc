class CECamera extends Camera;

var transient float FdTime;

var FCSceneCaptureActor NAG;
var array<FCSceneCaptureActor> CEActors;
var transient bool _Allow;
var transient CEGameInfo rGI; // Cache settings-object reference
var transient rSett; // Cache settings-object reference

simulated event PreBeginPlay(){
	 local SceneCapture2DComponent NC;
	 local FCSceneCaptureActor NA;
	 local array<TextureRenderTarget2D> Textures;
	 local int i;
	 local rotator str;
	 
	 rGI = CEGameInfo(WorldInfo.Game);
	 if(rGI==none) return;
	 rSett = CEMapInfo(WorldInfo.GetMapInfo());
	 if(rSett==none) return;
	 _Allow = true;
	 
	 Textures = rSett.RenderTextures;
	 
	 `Log("event::PreBeginPlay", "FishType="$rSett.FishType);
	 str = Rotation;
	 setRotation(rot(0,0,0));
	 switch(rSett.FishType){
		 case FE4a:
			 i = 0;
			 foreach AllActors(class'FCSceneCaptureActor', NA){
				 if(i>=4) break;
				 i++;
				}
			 if(i<4){
				 while(i++<4){
					 Spawn(class'FCSceneCaptureActor', self, , Location, Rotation);
					}
				}
			 i = 0;
			 foreach AllActors(class'FCSceneCaptureActor', NA){
				 if(i>=4) break;
				 i++;
				 if(NA.SceneCapture!=none)
					 NC = SceneCapture2DComponent(NA.SceneCapture);
				 if(NC==none)
					 NC = new(self) class'SceneCapture2DComponent';
				 NA.SetBase(self);
				 NA.SetRelativeLocation(vect(0,0,0));
				 NA.bDebug = bDebug;
				 switch(i){
					 case 1:
						 if(Textures.Length>0&&Textures[0]!=none) NC.SetCaptureParameters(Textures[0]);
							else NC.SetCaptureParameters(TextureRenderTarget2D'fishFX.Texture.Cam1');
						 NAG = NA;
						 NA.R = 255;
						 NA.G = 255;
						 NA.B = 255;
						break;
					 case 2:
						 if(Textures.Length>1&&Textures[1]!=none) NC.SetCaptureParameters(Textures[1]);
							else NC.SetCaptureParameters(TextureRenderTarget2D'fishFX.Texture.Cam2');
						 NA.SetRelativeRotation(rot(16384,0,0));
						 NA.R = 0;
						 NA.G = 255;
						 NA.B = 0;
						break;
					 case 3:
						 if(Textures.Length>2&&Textures[2]!=none) NC.SetCaptureParameters(Textures[2]);
							else NC.SetCaptureParameters(TextureRenderTarget2D'fishFX.Texture.Cam3');
						 NA.SetRelativeRotation(rot(0,16384,0));
						 NA.R = 0;
						 NA.G = 255;
						 NA.B = 255;
						break;
					 case 4:
						 if(Textures.Length>3&&Textures[3]!=none) NC.SetCaptureParameters(Textures[3]);
							else NC.SetCaptureParameters(TextureRenderTarget2D'fishFX.Texture.Cam4');
						 NA.SetRelativeRotation(rot(0,-16384,0));
						 NA.R = 255;
						 NA.G = 255;
						 NA.B = 0;
						break;
					}
				 NC.SetCaptureParameters( , 90.0, 10.000000, 1000000.000000);
				 NC.ViewMode = ViewMode;
				 NC.bEnableFog = bEnableFog;
				 NC.bUseMainScenePostProcessSettings=True;
				 NC.bSkipRenderingDepthPrepass=False;
				 if(NumFrameRate>0) NC.SetFrameRate(rSett.NumFrameRate);
				 NC.SetEnabled(true);
				 NA.AttachComponent(NC);
				 NC = none;
				 CEActors.AddItem(NA);
				}
			break;
		}
	 setRotation(str);
	}

function FadeInOut(float DeltaTime){
	 FdTime = DeltaTime/2;
	 FadeToBlack(FdTime);
	 SetTimer(FdTime, false, 'timer_fadeOut');
	}
function timer_fadeOut(){
	 FadeToNormal(FdTime);
	}

/***********************************
*DeltaTime 
*FadeFrom 0-1 1=black
*FadeTo 0-1 1=black
************************************/
function FadeTo(float DeltaTime,float FadeFrom,float FadeTo)
{
   bEnableFading=true;
   FadeTimeRemaining=DeltaTime;
   FadeTime=DeltaTime;
   FadeAlpha.X=FadeFrom;
   FadeAlpha.Y=FadeTo;
}

/***********************************
*FadingToBlack
************************************/
function FadeToBlack(float DeltaTime)
{
   FadeTo(DeltaTime,0,1);
}

/***********************************
*Clear Fade Effect
*************************************/
function FadeToNormal(float DeltaTime)
{
   FadeTo(DeltaTime,1,0);
}

defaultproperties
{
	DefaultFOV=90.f
	DefaultAspectRatio=1
	ViewMode = SceneCapView_Lit
}
