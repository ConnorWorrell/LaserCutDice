offset = 20;

DiceToLayout=[4,6,8,10,12,20];
XDimmOverride = 0;
YDimmOverride = 0;

function addl(list, c = 0) = 
 c < len(list) - 1 ? 
 list[c] + addl(list, c + 1) 
 :
 list[c];

TotalDice=addl(DiceToLayout);
assert(XDimmOverride * YDimmOverride == 0 || !(XDimmOverride * YDimmOverride < TotalDice), "Too few layout locations, increase XDimm or YDimm");

MaxOverrideDimension = max([XDimmOverride, YDimmOverride]);

XDimm = XDimmOverride == 0 ? (MaxOverrideDimension != 0 ? round(TotalDice/MaxOverrideDimension) : round(sqrt(TotalDice))) : XDimmOverride;
YDimm = YDimmOverride == 0 ? round(TotalDice/XDimm) : YDimmOverride;

DiceValue = [for (i=DiceToLayout) each [for (p=[1:i]) ((p == 6 || p == 9) && i >= 9 ? str(str(p),".") : p)]];
DiceSides = [for (i=DiceToLayout) each [for (p=[1:i]) i]];

echo(DiceValue)

for (xPos=[0:XDimm-1],yPos=[0:YDimm-1]){
    absPos = xPos*YDimm+yPos;
    
    Value = str(DiceValue[absPos]);
    Sides = str(DiceSides[absPos]);
    
    translate([xPos*offset,yPos*offset])rotate([0,0,45])import(str("D",Sides,"_Export/D",Sides,"-",Value,".dxf"));
    echo(str("D",Sides,"_Export/D",Sides,"-",Value,".dxf"), Value, Sides, absPos, xPos, yPos);
}