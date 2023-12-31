LaserRelief=.75; //Aproximate radius of laser beam
TabDepthRelief=.34; //Tuned so tabs are ~the same depth as the thickness
TabClearance = .6; //Tuned so tabs just barely stick together

BaseThickness = 1.5; //For stl export
TextThickness = 1; //For stl export
Sides = 4;
InscribedDiameterInput = 22.62741; //Diameter of circle that inscribes the tile
// 16mm D4:  22.6274
// 16mm D6:  22.6274
// 16mm D8:  22.62405
// 16mm D10:
// 16mm D12: 12.2262 for 1.5mm base thickness the geometry for this needs to be bigger to function
// 16mm D20: 
InscribedDiameter = InscribedDiameterInput;
TabCount = 2; //Minimum 2 tabs
TabDepth = BaseThickness+LaserRelief+TabDepthRelief;

D10=false;

Text = "1";
TextRotation = D10==false?-360/(Sides*2)+90:0; //Always align text with an edge
TextSize = InscribedDiameterInput*.254*(-1/Sides^2.5+1.5-2.5/Sides)*(D10==false?1:.5*InscribedDiameterInput/22.62741);



Offset = 0;
echo(Offset);

translate([Offset,0,0])difference(){offset(r=LaserRelief,chamfer=false,$fn=30) projection(cut=false)
    //Tile
linear_extrude(BaseThickness) tile(r=InscribedDiameter/2, order=Sides, tabs=TabCount, tablength=TabDepth);
    //Text
projection(cut=false)linear_extrude(BaseThickness+TextThickness)rotate([0,0,TextRotation])text(Text, halign="center",valign="center", size=TextSize);
}

 module tile(order = 4, r=1, tabs=2, tablength=3){
     cordsToCatD10=[[0,11.4834],[6.7015,-2.31554],[0,-5.58025],[-6.7015,-2.31554]]*InscribedDiameterInput/22.672741; //D10 shape
     
     angles=[ for (i = [0:order-1]) i*(360/order) ];
     cordsToCat=D10 == false ? [ for (th=angles) [r*cos(th), r*sin(th)] ] : cordsToCatD10;

         
     difference(){
         polygon(cordsToCat);
             
         //For each side
         for(j=[1:1:len(cordsToCat)]){
             firstPoint=cordsToCat[j-1];
             secondPoint=cordsToCat[j==len(cordsToCat)?0:j];
             parrSide = firstPoint-secondPoint;
             normSide=parrSide/norm(parrSide);
             
             parrVect=-parrSide/(tabs);
             perpVect=[normSide[1],-normSide[0]]*tablength;
             
             //Generate tabs to remove
             for(tab=[0:1:tabs-1]){
                 echo(tab)
                #polygon([firstPoint+parrVect*tab-perpVect-(tab==0&&!D10?parrVect:[0,0])+TabClearance*normSide, firstPoint+parrVect*tab+perpVect-(tab==0&&!D10?parrVect:[0,0])+TabClearance*normSide, firstPoint+parrVect*tab+perpVect+parrVect/2-TabClearance*normSide, 
        firstPoint+parrVect*tab+parrVect/2-perpVect-TabClearance*normSide]);
             }
        }
    }
 }