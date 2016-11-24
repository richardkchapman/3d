include <MCAD/nuts_and_bolts.scad>;

$fn=50;
// Tolerances for geometry connections.
AT=0.02;
ST=AT*2;
TT=AT/2;


module pillowBlock(centerHeight = 19, width=20)

// Separation between plates:
// 23mm to center of rail from bottom plate
// 15mm to center of rail from top plate
// 38mm total...

// NEMA14 height is (max) 35mm so we want center at least 17.5mm from bottom plate
// Call it 18mm, so we want 20mm (max) from top plate
{
  difference()
  {
    union()
    {
      translate([-bearingWidth/2,-bearingWidth/2,0])
      {
        difference()
        {
          cube([bearingWidth,bearingWidth,6]);
          bearingHoles(h=6,csk=false);
        }
      }
      translate([-width/2,-13,6])
        cube([width,26,31]);
      translate([-width/2,-15,6])
        cube([width,30,centerHeight-6]);
      translate([-width/2,0,centerHeight])
        rotate([0,90,0])
          cylinder(r=15,h=width);
    }
    translate([0,13,centerHeight+11+3])
      rotate([90,0,0])
        nutHole(4);
    translate([0,-9,centerHeight+11+3])
      rotate([90,0,0])
        cylinder(r=4,h=4);
    translate([0,22,centerHeight+11+3])
      rotate([90,0,0])
        cylinder(r=2,h=44);
    translate([-width/2,-1,20])
      cube([width,2,20]);
    translate([-width/2-1,0,centerHeight])
      rotate([0,90,0])
        cylinder(h=width+2,r=11);
  }
}

module nemaMount(mount_total_height = 35, shaft_height = 19)
{
// Nema mount
  
  NemaSideSize = 43.5;   // Allow a bit of tolerance
  NemaDistanceBetweenMountingHoles =  31.04;
  NemaMountingHoleDiameter = 4;
  NemaRoundExtrusionDiameter = 24;  // 22 in theory but give some clearance
  NemaShaftHole = 6;  // 5.5 would do but give some clearance
  NemaRoundExtrusionHeight = 2;
  NemaCornerChamfer = 2;

  mount_wall=3;
  mount_base = NemaSideSize/2 - shaft_height;

  centers=NemaSideSize/2+mount_base;
  difference()
  {
    translate([-(NemaSideSize+mount_wall*2)/2,0,0])
      cube([NemaSideSize+mount_wall*2, centers+NemaSideSize/2,mount_total_height]);
    translate([-NemaSideSize/2,centers-NemaSideSize/2,mount_wall])
      difference()
      {
        cube([NemaSideSize,NemaSideSize,mount_total_height]);
        rotate([90,0,90])
          prism(mount_total_height, NemaCornerChamfer, NemaCornerChamfer);
        translate([NemaSideSize,0,0])
          rotate([90,0,180])
            prism(mount_total_height, NemaCornerChamfer, NemaCornerChamfer);
        translate([0,NemaSideSize,0])
          rotate([90,0,0])
            prism(mount_total_height, NemaCornerChamfer, NemaCornerChamfer);
        translate([NemaSideSize,NemaSideSize,0])
          rotate([90,0,-90])
            prism(mount_total_height, NemaCornerChamfer, NemaCornerChamfer);
      }
    translate([-(NemaSideSize+mount_wall*2)/2,centers+NemaSideSize/2,mount_total_height+mount_wall])
      translate([-AT,0,0])
        rotate([90,90,0])
          prism(NemaSideSize+mount_wall*2+ST,mount_total_height,NemaSideSize);
    translate([0,centers,mount_wall-NemaRoundExtrusionHeight])
      cylinder(r=NemaRoundExtrusionDiameter/2,h=NemaRoundExtrusionHeight+AT);
    translate([0,centers,-AT])
      cylinder(r=NemaShaftHole/2,h=mount_wall+ST);
    translate([NemaDistanceBetweenMountingHoles/2,centers-NemaDistanceBetweenMountingHoles/2,0])
      cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
    translate([-NemaDistanceBetweenMountingHoles/2,centers-NemaDistanceBetweenMountingHoles/2,0])
      cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
    translate([NemaDistanceBetweenMountingHoles/2,centers+NemaDistanceBetweenMountingHoles/2,0])
      cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
    translate([-NemaDistanceBetweenMountingHoles/2,centers+NemaDistanceBetweenMountingHoles/2,0])
      cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
    translate([0, mount_total_height/2,0])
      rotate([90,0,0])
      {
      translate([NemaDistanceBetweenMountingHoles/2,centers-NemaDistanceBetweenMountingHoles/2,0])
        cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
      translate([-NemaDistanceBetweenMountingHoles/2,centers-NemaDistanceBetweenMountingHoles/2,0])
        cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
      translate([NemaDistanceBetweenMountingHoles/2,centers,0])
        cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
      translate([-NemaDistanceBetweenMountingHoles/2,centers,0])
        cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
      }
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

bearingWidth=42;
bearingHoleSpace=30.5;
bearingHoleEdge=(bearingWidth-bearingHoleSpace)/2;
bearingHoleEdge2=bearingHoleEdge+bearingHoleSpace;
plateThickness=5;
M5HoleRadius=5.5/2;

module csk_bolt(dia,len,csk)
{
  h1=0.6*dia;
  cylinder(r=dia/2,len);
  if(csk)
    translate([0,0,len-h1])
      cylinder(r2=dia,r1=dia/2,h=h1);
}

module bearingHoles(h=plateThickness, csk=true)
{
  translate([bearingHoleEdge,bearingHoleEdge,0])
    csk_bolt(M5HoleRadius*2,h,csk);
  translate([bearingHoleEdge,bearingHoleEdge2,0])
    csk_bolt(M5HoleRadius*2,h,csk);
  translate([bearingHoleEdge2,bearingHoleEdge,0])
    csk_bolt(M5HoleRadius*2,h,csk);
  translate([bearingHoleEdge2,bearingHoleEdge2,0])
    csk_bolt(M5HoleRadius*2,h,csk);
}

module sliderplate()
{
  difference()
  {
    cube([bearingWidth*3,bearingWidth*3,plateThickness]);
    bearingHoles();
    translate([bearingWidth*2,0,0]) bearingHoles();
    translate([0,bearingWidth*2,0]) bearingHoles();
    translate([bearingWidth*2,bearingWidth*2,0]) bearingHoles();
    translate([bearingWidth,bearingWidth*2,0]) bearingHoles();
  }
}

//sliderplate();
pillowBlock();
//nemaMount();

