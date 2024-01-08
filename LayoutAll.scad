offset = 20;

DiceToLayout=[
[4,"",""],
[6,"",""],
[8,"",""],
[10,"",""],
[12,"",""],
[20,"",""],
[6,"Skew","NSNR"],
[6,"Skew","NSR"],
[6,"Skew","SNR"]];
XDimmOverride = 0;
YDimmOverride = 0;

function addl(list, c = 0) = 
 c < len(list) - 1 ? 
 list[c] + addl(list, c + 1) 
 :
 list[c];

TotalDice=addl([for (i=DiceToLayout) i[0]]);
assert(XDimmOverride * YDimmOverride == 0 || !(XDimmOverride * YDimmOverride < TotalDice), "Too few layout locations, increase XDimm or YDimm");

MaxOverrideDimension = max([XDimmOverride, YDimmOverride]);

XDimm = XDimmOverride == 0 ? (MaxOverrideDimension != 0 ? round(TotalDice/MaxOverrideDimension) : round(sqrt(TotalDice))) : XDimmOverride;
YDimm = YDimmOverride == 0 ? round(TotalDice/XDimm) : YDimmOverride;

DiceValue = [for (i=DiceToLayout) each [for (p=[1:i[0]]) ((p == 6 || p == 9) && i[0] >= 9 ? str(str(p),".") : p)]];
DiceSides = [for (i=DiceToLayout) each [for (p=[1:i[0]]) i[0]]];
DiceFolderPrefix = [for (i=DiceToLayout) each [for (p=[1:i[0]]) i[1]]];
DiceTypePrefix = [for (i=DiceToLayout) each [for (p=[1:i[0]]) i[2]]];

echo(DiceValue)

for (xPos=[0:XDimm-1],yPos=[0:YDimm-1]){
    absPos = xPos*YDimm+yPos;
    
    Value = str(DiceValue[absPos]);
    Sides = str(DiceSides[absPos]);
    FolderPrefix = str(DiceFolderPrefix[absPos]);
    TypePrefix = str(DiceTypePrefix[absPos]);
    
    DiceLocation = FolderPrefix == "" && TypePrefix == ""
        ? str("D", Sides,"_Export/D",Sides,"-",Value,".dxf")
        : str("D", Sides,FolderPrefix,"_Export/",TypePrefix,"/D",Sides,FolderPrefix,TypePrefix,"-",Value,".dxf");
    
    translate([xPos*offset,yPos*offset])rotate([0,0,45])import(DiceLocation);
    echo(DiceLocation, Value, Sides, absPos, xPos, yPos);
}