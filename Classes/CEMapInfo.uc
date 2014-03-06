class CEMapInfo extends MapInfo
	DependsON(MAnimations);

enum CELang{
	 CEL_EN<DisplayName=English>,
	 CEL_UA<DisplayName=Ukraine>,
	 CEL_RU<DisplayName=Russian>,
	 CEL_Sys<DisplayName=System|bShowOnlyWhenTrue=False>,
	};
struct CEi18Str{
	 var() string Str;
	 var() CELang Lang;
	};

var(GameParams) float TimeModifier;				// Множник протікання часу

var(Laguage) CELang LanguageState;			//

var(DrawHUD) bool BlackScreen;				//
var(DrawHUD) bool DrawGrid;					//


defaultproperties
{
}