include <MCAD/nuts_and_bolts.scad>;

bearingWidth=44;   // Actually 42 but give ourselves a little space...
bearingLength=40;  // actually 36 but give ourselves a lttle space...
bearingHoleSpaceX=30.5;
bearingHoleSpaceY=26;
plateThickness=5;
plateThicknessB=10;
endplateThickness=10;
endplateThicknessB=5;
M5HoleRadius=5.5/2;
M25HoleRadius=3.0/2;
middleGap = 50;
bearingDiameter=26;
bearingShelfW=1.5;
bearingShelfD=1.5;
idlerDiameter=22;
idlerBore=8;
idlerDepth=7;
explode=1;
rodZ=15.2;
plateSpace=29;
hump=20;

$fn=50;
// Tolerances for geometry connections.
AT=0.02;
ST=AT*2;
TT=AT/2;

rodDiameter = 12;
rodCenters = 60;

endPlateThickness = 10;
endPlateLength = rodCenters + rodDiameter + 4;
endPlateHeight = rodDiameter + 4;

tabLength=40;
tabHeight=40;

module roundedRect(size, radius)
{
    x = size[0];
    y = size[1];
    z = size[2];
    linear_extrude(height=z)
    hull()
    {
        // place 4 circles in the corners, with the given radius
        translate([radius, radius, 0])
            circle(r=radius);
        translate([x-radius, radius, 0])
            circle(r=radius);
        translate([radius, y-radius, 0])
            circle(r=radius);
        translate([x-radius, y-radius, 0])
            circle(r=radius);
    }
}

//Draw a prism based on a 
//right angled triangle
//l - length of prism
//w - width of triangle
//h - height of triangle
module prism(l, w, h) {
       polyhedron(points=[
               [0,0,h],           // 0    front top corner
               [0,0,0],[w,0,0],   // 1, 2 front left & right bottom corners
               [0,l,h],           // 3    back top corner
               [0,l,0],[w,l,0]    // 4, 5 back left & right bottom corners
       ], faces=[ // points for all faces must be ordered clockwise when looking in
               [0,2,1],    // top face
               [3,4,5],    // base face
               [0,1,4,3],  // h face
               [1,2,5,4],  // w face
               [0,3,5,2],  // hypotenuse face
       ]);
}


module csk_bolt(dia,len,csk)
{
  h1=0.6*dia;
  cylinder(r=dia/2,len);
  if(csk)
    translate([0,0,len-h1])
      cylinder(r2=dia,r1=dia/2,h=h1);
}

module bearingHoles(h=plateThickness, csk=true, bw = bearingWidth, bl = bearingLength, sx = bearingHoleSpaceX, sy = bearingHoleSpaceY)
{
  bearingHoleEdge=(bw-sx)/2;
  bearingHoleEdgeY=(bl-sy)/2;
  bearingHoleEdge2=bearingHoleEdge+sx;
  bearingHoleEdge2Y=bearingHoleEdgeY+sy;
  translate([bearingHoleEdge,bearingHoleEdgeY,0])
    csk_bolt(M5HoleRadius*2,h,csk);
  translate([bearingHoleEdge,bearingHoleEdge2Y,0])
    csk_bolt(M5HoleRadius*2,h,csk);
  translate([bearingHoleEdge2,bearingHoleEdgeY,0])
    csk_bolt(M5HoleRadius*2,h,csk);
  translate([bearingHoleEdge2,bearingHoleEdge2Y,0])
    csk_bolt(M5HoleRadius*2,h,csk);
}

module sliderplate(left=true, holes=true, holerad=3)
{
  difference()
  {
    union()
    {
      translate([0,-tabLength,0])
        roundedRect([tabHeight, tabLength+10,plateThickness],2);
      roundedRect([bearingWidth+rodCenters,bearingLength*2+middleGap,plateThickness],2);
      translate([(rodCenters+bearingWidth)/2,bearingLength+middleGap*0.5,0])
        cylinder(d=bearingDiameter+8, h=plateThicknessB);
      translate([0,-10,0]) cube([tabHeight+10,12,plateThickness]);
    }
    bearingHoles();
    translate([tabHeight/2,-tabLength+10,0])
       csk_bolt(M5HoleRadius*2,plateThickness,true);
    translate([tabHeight,-20,-1])
      roundedRect([20,20,plateThickness+2],2);

    translate([rodCenters,0,0]) bearingHoles();
    translate([0,bearingLength+middleGap,0]) bearingHoles();
    translate([rodCenters,bearingLength+middleGap,0]) bearingHoles();
    translate([(rodCenters+bearingWidth)/2,bearingLength+middleGap*0.5,0])
      union()
      {
        cylinder(d=bearingDiameter-bearingShelfW, h=plateThicknessB);
        translate([0,0,bearingShelfD])
          cylinder(d=bearingDiameter, h=plateThicknessB-bearingShelfD);
      }
    translate([idlerBore/2 + 4, bearingLength+idlerDiameter/2,0]) 
        cylinder(d=idlerBore,h=plateThickness);
    translate([idlerBore/2 + 4, bearingLength+middleGap-idlerDiameter/2,0]) 
        cylinder(d=idlerBore,h=plateThickness);
    if (holes)
    {
      translate([bearingWidth/2-10,bearingLength/2-8,0]) roundedRect([20,16,plateThickness],holerad);
      translate([bearingWidth/2-10+rodCenters,bearingLength/2-8,0]) roundedRect([20,16,plateThickness],holerad);
      translate([bearingWidth/2-10,bearingLength*1.5+middleGap-8,0]) roundedRect([20,16,plateThickness],holerad);
      translate([bearingWidth/2-10+rodCenters,bearingLength*1.5+middleGap-8,0]) roundedRect([20,16,plateThickness],holerad);
      translate([idlerBore+8,bearingLength,0]) roundedRect([20+(bearingWidth/2-10)-(idlerBore+8),middleGap,plateThickness],holerad);
      translate([bearingWidth/2-10+rodCenters,bearingLength,0]) roundedRect([20,middleGap,plateThickness],holerad);
      translate([bearingWidth/2-10+rodCenters/2,bearingLength*1.5+middleGap-8,0]) roundedRect([20,16,plateThickness],holerad);
      translate([bearingWidth/2-10+rodCenters/2,bearingLength*0.5-8,0]) roundedRect([20,16,plateThickness],holerad);
      translate([10,-tabLength+20,0]) roundedRect([tabHeight-20,tabLength-20,plateThickness],holerad);
    }
  }
}

module idler()
{
  difference()
  {
    cylinder(d=idlerDiameter,h=idlerDepth);
    cylinder(d=idlerBore,h=idlerDepth);
  }
}

module rod()
{
  translate([0,-50,-rodZ]) rotate([-90,0,0]) cylinder(d=12,h=bearingLength*2+middleGap+100);
}

module bottomPlate()
{
  intersection()
    {
      sliderplate(holes=false);
      translate([bearingWidth/2+hump/2,bearingLength/2+bearingHoleSpaceY/2-6,0]) roundedRect([rodCenters-hump,middleGap+bearingLength-bearingHoleSpaceY/2,plateThicknessB], 2);
    }
}

module end()
{
  additionalHeight = idlerDiameter/2-(idlerBore/2 + 4);
  difference()
  {
    union()
    {
      linear_extrude(height=endplateThickness)
        hull()
        {
          translate([2-additionalHeight-endplateThicknessB,2,0]) circle(r=2);
          translate([bearingWidth+rodCenters-2,2,0]) circle(r=2);
          translate([bearingWidth+rodCenters-4,rodZ*2,0]) circle(r=4);
          translate([2-additionalHeight-endplateThicknessB,bearingLength*2+middleGap-2,0]) circle(r=2);
          translate([bearingWidth/2,bearingLength*2+middleGap-4,0]) circle(r=4);
        }
        translate([-additionalHeight-endplateThicknessB,0,0])
          roundedRect([additionalHeight+endplateThicknessB, bearingLength*2+middleGap, endplateThickness+15], 2);
    }
    translate([bearingWidth/2,rodZ*2,-1])
      linear_extrude(height=endplateThickness+2)
        hull()
        {
          translate([2,2,0]) circle(r=2);
          translate([rodCenters-2,2,0]) circle(r=2);
          translate([2,bearingLength*2+middleGap-8-rodZ*2-bearingWidth/2,0]) circle(r=2);

       //   translate([bearingWidth+rodCenters-1,rodZ*2,0]) circle(r=2)          
         // translate([1,bearingLength*2+middleGap-1,0]) circle(r=2);
         // translate([15,bearingLength*2+middleGap-1,0]) circle(r=2);
        } 
    translate([bearingWidth/2,rodZ,-1])
      cylinder(d=12,h=endplateThickness+2);
    translate([bearingWidth/2 + rodCenters,rodZ,-1])
      cylinder(d=12,h=endplateThickness+2);
  }
}

/*
rotate([0,-90,180]) {
    
sliderplate(left=true);
 translate([0,0,-plateSpace]) mirror([0,0,1]) bottomPlate();
bottomPlate();

translate([bearingWidth/2,0,0]) rod();
translate([rodCenters+bearingWidth/2,0,0]) rod();
translate([idlerBore/2 + 4, bearingLength+idlerDiameter/2,-idlerDepth - explode]) idler();
translate([idlerBore/2 + 4, bearingLength+middleGap-idlerDiameter/2,-idlerDepth - explode]) idler();
translate([(rodCenters+bearingWidth)/2,bearingLength+middleGap/2,-16-explode]) import("/Users/rchapman/Documents/OpenSCAD/libraries/MXL32.stl");
rotate([-90,0,0])
  translate([0,0, - tabLength - 20]) 
    end();
}
*/
end();
