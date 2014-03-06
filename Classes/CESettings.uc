class CESettings extends Object
	Config(CESettings)
	DependsON(MAnimations);

var(Animation) globalconfig MAni_Info DefChCamera;
var(Debug) globalconfig color DebugColor;

// Налаштування камери
const FE4a		= 0;
var(Camera) enum FishTypes{
	 FE4a,
	} FishType;						// Тип утворення FishEye
var(Camera) float NumFrameRate;		// Кількість кадрів
var(Camera) array<TextureRenderTarget2D> RenderTextures;

function save(){
	 SaveConfig();
	}

defaultproperties
{
}