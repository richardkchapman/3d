include <MCAD/nuts_and_bolts.scad>;

bearingWidth=44;   // Actually 42 but give ourselves a little space...
bearingLength=40;  // actually 36 but give ourselves a lttle space...
bearingHoleSpaceX=30.5;
bearingHoleSpaceY=26;
plateThickness=5;
M5HoleRadius=5.5/2;
M25HoleRadius=3.0/2;


$fn=50;
// Tolerances for geometry connections.
AT=0.02;
ST=AT*2;
TT=AT/2;

rodDiameter = 12;
leadscrewDiameter = 10;
rodCenters = bearingWidth + leadscrewDiameter + 3; // 5mm total clearance as we added padding to bearingWidth
endPlateThickness = 10;
endPlateLength = rodCenters + rodDiameter + 4;
endPlateHeight = rodDiameter + 4;

NemaSideSize = 43.5;   // Allow a bit of tolerance
footLength = 22;
footHeight = 5;
footWidth = NemaSideSize;
switchPlateWidth = 13;
footHoleSpacing = 30;

module endPlate()
{
  bearingDiameter = 22;
  pinchHoleY = (rodCenters-rodDiameter-bearingDiameter)/4+bearingDiameter/2;
  difference()
  {
    // Bar with circular ends
    union()
    {
      // Bar with circular ends
      cube([endPlateThickness, rodCenters, endPlateHeight],center=true);
      translate([-endPlateThickness/2,rodCenters/2,0])
        rotate([0,90,0])
          cylinder(r=endPlateHeight/2,h=endPlateThickness);
      translate([-endPlateThickness/2,-rodCenters/2,0])
        rotate([0,90,0])
          cylinder(r=endPlateHeight/2,h=endPlateThickness);
      // Bearing holder
      translate([-endPlateThickness/2,0,0])
        rotate([0,90,0])
          cylinder(r=bearingDiameter/2+2,h=endPlateThickness);
      // foot
      translate([-endPlateThickness/2,-footWidth/2,-NemaSideSize/2])
        cube([endPlateThickness, footWidth, NemaSideSize/2]);
      translate([-endPlateThickness/2,-footWidth/2,-NemaSideSize/2])
        roundedRect([footLength, footWidth, footHeight],2);
    }
    // Holes for rods
    union()
    {
      translate([-endPlateThickness/2,rodCenters/2,0])
        rotate([0,90,0])
          cylinder(r=rodDiameter/2,h=endPlateThickness);
      translate([-endPlateThickness/2,-rodCenters/2,0])
        rotate([0,90,0])
          cylinder(r=rodDiameter/2,h=endPlateThickness);
    }
    // Hole for bearing
    translate([-endPlateThickness/2,,0])
      rotate([0,90,0])
        cylinder(r=bearingDiameter/2,h=endPlateThickness);
    // Pinch slot
    cube([endPlateThickness, rodCenters, 2],center=true);
    // pinch holes
    translate([0,pinchHoleY,-endPlateHeight/2])
    {
      nutHole(4);
      translate([0,-3.5,-1])
        cube([endPlateThickness/2+1,7,4]);
    }
    translate([0,pinchHoleY,-endPlateHeight/2])
      cylinder(r=2,h=endPlateHeight);
    translate([0,pinchHoleY,endPlateHeight/2-3])
      cylinder(r=3.5,h=3);
    translate([0,-pinchHoleY,-endPlateHeight/2])
    {
      nutHole(4);
      translate([0,-3.5,-1])
        cube([endPlateThickness/2+1,7,4]);
    }
    translate([0,-pinchHoleY,-endPlateHeight/2])
      cylinder(r=2,h=endPlateHeight);
    translate([0,-pinchHoleY,endPlateHeight/2-3])
      cylinder(r=3.5,h=3);
    // Foot mounting holes
    csk_plate = false;
    translate([endPlateThickness/2+6,0,-NemaSideSize/2])
      csk_bolt(M5HoleRadius*2,footHeight,csk_plate);
/*    translate([footLength-endPlateThickness/2-6,footHoleSpacing/2,-NemaSideSize/2])
      csk_bolt(M5HoleRadius*2,footHeight,csk_plate);
    translate([footLength-endPlateThickness/2-6,-footHoleSpacing/2,-NemaSideSize/2])
      csk_bolt(M5HoleRadius*2,footHeight,csk_plate);
  */
  }
}

module motorPlate(isMotor=true)
{
  NemaDistanceBetweenMountingHoles =  31.04;
  NemaMountingHoleDiameter = 4;
  NemaRoundExtrusionDiameter = 24;  // 22 in theory but give some clearance
  BearingDiameter = 22;
  pinchHoleY = rodCenters/2+rodDiameter/2+3;
  difference()
  {
    // Bar with circular ends
    union()
    {
      // Bar with circular ends
      //cube([endPlateThickness, rodCenters+rodDiameter+16, endPlateHeight],center=true);
      translate([-endPlateThickness/2, -(rodCenters+rodDiameter+16)/2, -endPlateHeight/2])
        roundedRect([endPlateThickness, rodCenters+rodDiameter+16, endPlateHeight],2);

      translate([-endPlateThickness/2,rodCenters/2,0])
        rotate([0,90,0])
          cylinder(r=endPlateHeight/2,h=endPlateThickness);
      translate([-endPlateThickness/2,-rodCenters/2,0])
        rotate([0,90,0])
          cylinder(r=endPlateHeight/2,h=endPlateThickness);
      // Motor holder
      translate([endPlateThickness/2,-NemaSideSize/2,-NemaSideSize/2])
        rotate([0,-90,0])
          roundedRect([NemaSideSize, NemaSideSize, endPlateThickness],2)
      // foot
      translate([-endPlateThickness/2,-footWidth/2,-NemaSideSize/2])
        cube([endPlateThickness, footWidth, NemaSideSize/2]);
      translate([-endPlateThickness/2,-footWidth/2,-NemaSideSize/2])
        roundedRect([footLength, footWidth, footHeight],2);
      translate([-endPlateThickness/2,-(rodCenters+switchPlateWidth)/2,-NemaSideSize/2])
        roundedRect([footLength, switchPlateWidth+10, footHeight],2); // 10 is a fudge to merge into foot...
    }
    // Holes for rods
    union()
    {
      translate([-endPlateThickness/2,rodCenters/2,0])
        rotate([0,90,0])
          cylinder(r=rodDiameter/2,h=endPlateThickness);
      translate([-endPlateThickness/2,-rodCenters/2,0])
        rotate([0,90,0])
          cylinder(r=rodDiameter/2,h=endPlateThickness);
    }
    // Hole for motor
    translate([-endPlateThickness/2,,0])
      rotate([0,90,0])
        if (isMotor)
          cylinder(r=NemaRoundExtrusionDiameter/2,h=endPlateThickness);
        else
          cylinder(r=BearingDiameter/2,h=endPlateThickness);
    // Pinch slots
    translate([-endPlateThickness/2,-(rodCenters+rodDiameter+16)/2,-1])
      cube([endPlateThickness, 10, 2]);
    translate([-endPlateThickness/2,(rodCenters+rodDiameter+16)/2-10,-1])
      cube([endPlateThickness, 10, 2]);
    // pinch holes
    translate([0,pinchHoleY,-endPlateHeight/2])
      nutHole(4);
    translate([0,pinchHoleY,-endPlateHeight/2])
      cylinder(r=2,h=endPlateHeight);
    translate([0,pinchHoleY,endPlateHeight/2-3])
      cylinder(r=3.5,h=3);
    translate([0,-pinchHoleY,-endPlateHeight/2])
      nutHole(4);
    translate([0,-pinchHoleY,-endPlateHeight/2])
      cylinder(r=2,h=endPlateHeight);
    translate([0,-pinchHoleY,endPlateHeight/2-3])
      cylinder(r=3.5,h=3);
    holeOffset = NemaDistanceBetweenMountingHoles/2;
    if (isMotor)
    {
      // Motor screw holes
      translate([-endPlateThickness/2,holeOffset,holeOffset])
        rotate([0,90,0])
        {
          cylinder(r=NemaMountingHoleDiameter/2,h=endPlateThickness);
          translate([0,0,endPlateThickness])
            cylinder(r=3.2,h=10);
        }
      translate([-endPlateThickness/2,-holeOffset,holeOffset])
        rotate([0,90,0])
        {
          cylinder(r=NemaMountingHoleDiameter/2,h=endPlateThickness);
          translate([0,0,endPlateThickness])
            cylinder(r=3.2,h=10);
        }
      translate([-endPlateThickness/2,holeOffset,-holeOffset])
        rotate([0,90,0])
        {
          cylinder(r=NemaMountingHoleDiameter/2,h=endPlateThickness);
          translate([0,0,endPlateThickness])
            cylinder(r=3.2,h=10);
        }
      translate([-endPlateThickness/2,-holeOffset,-holeOffset])
        rotate([0,90,0])
        {
          cylinder(r=NemaMountingHoleDiameter/2,h=endPlateThickness);
          translate([0,0,endPlateThickness])
            cylinder(r=3.2,h=10);
        }
    }
    else
    {
      translate([0,NemaSideSize/2,holeOffset])
        rotate([90,0,0])
          nutHole(4);
      translate([0,-NemaSideSize/2+4,holeOffset])
        rotate([90,0,0])
          cylinder(r=4,h=4);
      translate([0,NemaSideSize/2,holeOffset])
        rotate([90,0,0])
          cylinder(r=2,h=NemaSideSize);
      translate([-endPlateThickness/2,-1,0])
        cube([endPlateThickness, 2, NemaSideSize/2]);
    }
    // Foot mounting holes
    csk_plate=false;
    translate([endPlateThickness/2+6,0,-NemaSideSize/2])
      csk_bolt(M5HoleRadius*2,footHeight,csk_plate);
    translate([footLength-endPlateThickness/2-4,-rodCenters/2-3,-NemaSideSize/2])
      rotate([0,180,0]) translate([0,0,-footHeight])
        csk_bolt(M25HoleRadius*2,footHeight,true);
    translate([footLength-endPlateThickness/2-4,-rodCenters/2+3,-NemaSideSize/2])
      rotate([0,180,0]) translate([0,0,-footHeight])
        csk_bolt(M25HoleRadius*2,footHeight,true);
    /*
    translate([footLength-endPlateThickness/2-6,footHoleSpacing/2,-NemaSideSize/2])
      csk_bolt(M5HoleRadius*2,footHeight,csk_plate);
    translate([footLength-endPlateThickness/2-6,-footHoleSpacing/2,-NemaSideSize/2])
      csk_bolt(M5HoleRadius*2,footHeight,csk_plate);
    */
  }
}

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

module pillowBlock(centerHeight = 15, width=18)
{
  difference()
  {
    union()
    {
      rotate([0,0,90])
        translate([-bearingWidth/2,-bearingLength/2,0])
        {
          difference()
          {
            cube([bearingWidth,bearingLength,3.5]);
            bearingHoles(h=4,csk=false);
          }
        }
      translate([-width/2,-13,0])
        cube([width,26,34]);
//      translate([-width/2,-15,0])
  //      cube([width,30,centerHeight]);
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

module nemaMount(mount_total_height = 4, shaft_height = 19)
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

module sliderplate(holes=true, holerad=3)
{
  difference()
  {
    roundedRect([bearingWidth+rodCenters,bearingLength*3,plateThickness],2);
    bearingHoles();
    translate([rodCenters,0,0]) bearingHoles();
    translate([0,bearingLength*2,0]) bearingHoles();
    translate([rodCenters,bearingLength*2,0]) bearingHoles();
    translate([rodCenters/2,bearingLength,0]) bearingHoles();
    translate([(bearingWidth+rodCenters)/2, (bearingLength*3)/2-30,0])
      cylinder(r=3,h=plateThickness);
    translate([(bearingWidth+rodCenters)/2, (bearingLength*3)/2+30,0])
      cylinder(r=3,h=plateThickness);
    if (holes)
    {
      translate([bearingWidth/2-10,bearingLength/2-8,0]) roundedRect([20,16,plateThickness],holerad);
      translate([bearingWidth/2-10+rodCenters,bearingLength/2-8,0]) roundedRect([20,16,plateThickness],holerad);
      translate([bearingWidth/2-10,bearingLength*2.5-8,0]) roundedRect([20,16,plateThickness],holerad);
      translate([bearingWidth/2-10+rodCenters,bearingLength*2.5-8,0]) roundedRect([20,16,plateThickness],holerad);
      translate([bearingWidth/2-12,bearingLength*1.5-18,0]) roundedRect([16,36,plateThickness],holerad);
      translate([bearingWidth/2-4+rodCenters,bearingLength*1.5-18,0]) roundedRect([16,36,plateThickness],holerad);
      translate([bearingWidth/2-8+rodCenters/2,bearingLength*1.5-18,0]) roundedRect([16,36,plateThickness],holerad);
      translate([bearingWidth/2-10+rodCenters/2,bearingLength*2.5-2,0]) roundedRect([20,10,plateThickness],holerad);
      translate([bearingWidth/2-10+rodCenters/2,bearingLength*0.5-8,0]) roundedRect([20,10,plateThickness],holerad);
    }
  }
}

//sliderplate();

//pillowBlock();
//translate([100,0,0])
  //rotate([0,0,180])
    //endPlate();
motorPlate(false);

module tower()
{
  difference()
  {
    cube([10,10,35]);
    translate([0.5,0.5,1])
      cube([9,9,34]);
  }
}