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
cordsToCatD10=[[0,11.4834],[6.7015,-2.31554],[0,-5.58025],[-6.7015,-2.31554]]*InscribedDiameterInput/22.672741; //D10 shape

D4=false;
D4Pattern = [[1,2,4],[1,3,2],[1,4,3],[2,3,4]];
D4Offset = 4;

//Parameters to generate a "skew dice" variant, modified from origional code by Carlos Luna (carlos.luna@mmaca.cat)
D6Skew=false;
D6Phase=30;
D6Stretch=1;
assert(0 <= D6Stretch);
assert(0 <= D6Phase && D6Phase <= 120);
cordsToCatD6Skew = skewDiceGenerator(phase=D6Phase,stretch=D6Stretch)*InscribedDiameterInput/1.6329875;

Text = "1";
TextSizeOverride=0;
TextRotation = D10==false?(D6Skew==false?-360/(Sides*2)+90:0):0; //Always align text with an edge
TextSize = TextSizeOverride==0?InscribedDiameterInput*.254*(-1/Sides^2.5+1.5-2.5/Sides)*(D10==false?1:.5*InscribedDiameterInput/22.62741):TextSizeOverride;

Offset = 0;

cordsOverride = D10==true ? cordsToCatD10 : (D6Skew==true ? cordsToCatD6Skew : []);

translate([Offset,0,0])difference(){offset(r=LaserRelief,chamfer=false,$fn=30) projection(cut=false)
    //Tile
    linear_extrude(BaseThickness) tile(r=InscribedDiameter/2, order=Sides, tabs=TabCount, tablength=TabDepth, cordsOverride=cordsOverride);
    //Text
    if(D4 == false){
        projection(cut=false)linear_extrude(BaseThickness+TextThickness)rotate([0,0,TextRotation])text(Text, halign="center",valign="center", size=TextSize);
    }
    else{
        //If text is even we do the right handed pattern, if it is odd we do the left handed pattern.
        D4PatternToCut=D4Pattern[ord(Text)-49]; //-48 to convert to int, and -1 to change 1 to 0

        projection(cut=false)linear_extrude(BaseThickness+TextThickness)rotate([0,0,TextRotation])translate([0,D4Offset,0])text(str(D4PatternToCut[0]), halign="center",valign="center", size=TextSize);
        projection(cut=false)linear_extrude(BaseThickness+TextThickness)rotate([0,0,TextRotation+120])translate([0,D4Offset,0])text(str(D4PatternToCut[1]), halign="center",valign="center", size=TextSize);
        projection(cut=false)linear_extrude(BaseThickness+TextThickness)rotate([0,0,TextRotation+120*2])translate([0,3,0])text(str(D4PatternToCut[2]), halign="center",valign="center", size=TextSize);
    }
}

 module tile(order = 4, r=1, tabs=2, tablength=3, cordsOverride=[]){

     
     angles=[ for (i = [0:order-1]) i*(360/order) ];
     cordsToCat = cordsOverride==[] ? [ for (th=angles) [r*cos(th), r*sin(th)] ] : cordsOverride;

         
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
                polygon([firstPoint+parrVect*tab-perpVect-(tab==0&&!D10?parrVect:[0,0])+TabClearance*normSide, firstPoint+parrVect*tab+perpVect-(tab==0&&!D10?parrVect:[0,0])+TabClearance*normSide, firstPoint+parrVect*tab+perpVect+parrVect/2-TabClearance*normSide, 
        firstPoint+parrVect*tab+parrVect/2-perpVect-TabClearance*normSide]);
             }
        }
    }
 }
 
 function addl(list, c = 0) = 
 c < len(list) - 1 ? 
 list[c] + addl(list, c + 1) 
 :
 list[c];
 
 function skewDiceGenerator(phase=30, stretch=1, size=16) = 
    // Constants:
    let (K = sqrt(3))
    let (R = size*K/2)
    let (C = cos(phase))
    let (S = sin(phase))
    
    // Coordinates of the main equatorial vertex: [X,0,Z]
    let (L = (C-1)*(S-K/2) - S*(C+1/2))  // <= Geometric Voodoo
    let (Z = L/(L-K))                    // <= Geometric Voodoo
    let (X = sqrt(1-Z*Z))
     
    // Vertical scaling factor:
    let (v_scale = (stretch == 0) ? (X/((1-Z)*sqrt(2))) : stretch)
    
    // Derivation of all other vertices from the vertex: [X,0,Z]
    let(initial = [[0,0,0],[-X/2,K*X/2,(Z-1)*v_scale],[C*X,S*X,-(Z+1)*v_scale],[X,0,(Z-1)*v_scale]])
 
    //Begin of adjusting to work for this program
    //Rotate around the x and y axis to get all points onto the XY plane
    let(yRotation = atan(initial[3][2]/initial[3][0]))
    let(yRotMatrix = [[cos(yRotation),0,sin(yRotation)],[0,1,0],[-sin(yRotation),0,cos(yRotation)]])
    //initial;
    let(yRotated = [ for (i = initial) yRotMatrix*i])
    
    let(xRotation = -atan(yRotated[1][2]/yRotated[1][1]))
    let(xRotMatrix = [[1,0,0],[0,cos(xRotation),-sin(xRotation)],[0,sin(xRotation),cos(xRotation)]])
    
    let(xRotated = [for (i = yRotated) xRotMatrix*i])
        
    //Center the cube
    let(tile=[for (i = xRotated) [i[0],i[1]]])
    let(xAvg= addl([for (i=tile) i[0]])/4)
    let(yAvg= addl([for (i=tile) i[1]])/4)
    [for (i=tile) [i[0]-xAvg,i[1]-yAvg]];