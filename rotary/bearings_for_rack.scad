include <MCAD/nuts_and_bolts.scad>;

bearingHoleSpaceX=30.5;
bearingHoleSpaceY=26;
plateThickness=9;
basePlateThickness = 4;
M5HoleRadius=5.5/2;

bearingDiameter = 26;
pinionSpace=10;
rackHeight = 5;
delta = 1;
boltClearance=15;
$fn=50;

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

module bearing_holder()
{
  difference()
  {
    union()
    {
      roundedRect([(bearingHoleSpaceX+10 - pinionSpace)/2,bearingHoleSpaceY+10,basePlateThickness], 1);
      translate([(bearingHoleSpaceX+10 - pinionSpace)/2-plateThickness,0,0])
        roundedRect([plateThickness, bearingHoleSpaceY+10,rackHeight+bearingDiameter+9], 1);
    }
    translate([5,5,-delta]) cylinder(r=M5HoleRadius, h=basePlateThickness+delta*2);
    translate([5,5+bearingHoleSpaceY,-delta]) cylinder(r=M5HoleRadius, h=basePlateThickness+delta*2);
    translate([5,5,basePlateThickness/2]) cylinder(r=4.2, h=boltClearance);
    translate([5,5+bearingHoleSpaceY,basePlateThickness/2]) cylinder(r=4.2, h=boltClearance);
    translate([(bearingHoleSpaceX+10 - pinionSpace)/2-plateThickness-delta,(bearingHoleSpaceY+10)/2,rackHeight+bearingDiameter/2])
      rotate([0,90,0]) cylinder(r=bearingDiameter/2, h=plateThickness+delta*2);
    translate([(bearingHoleSpaceX+10 - pinionSpace)/2-plateThickness-delta,(bearingHoleSpaceY+10)/2-1.5,rackHeight+bearingDiameter-delta])
      cube([plateThickness+delta*2, 3, 8+delta*2]);  
    translate([(bearingHoleSpaceX+10 - pinionSpace)/2-plateThickness/2,-delta,rackHeight+bearingDiameter+4])
      rotate([-90,0,0])
        cylinder(r=2,h=bearingHoleSpaceY+10+delta*2);
    translate([(bearingHoleSpaceX+10 - pinionSpace)/2-plateThickness/2,0,rackHeight+bearingDiameter+4])
      rotate([-90,30,0])
        nutHole(4);
    translate([+(bearingHoleSpaceX+10 - pinionSpace)/2-plateThickness/2,bearingHoleSpaceY+7,rackHeight+bearingDiameter+4])
      rotate([90,30,0])
        boltHole(4);
  }
}

module rod_holder()
{
  rod=12;
  centerHeight=23;
  clearance = 0;
  holeSpace = 31.5;
  base = 6.5;
  depth = 14;
  aboveRod = 9;
  besideRod = 4;
  rackMountHole = 26;
  difference()
  {
    union()
    {
      translate([0,-(rod+besideRod*2)/2,0]) roundedRect([centerHeight + aboveRod + rod/2, rod+besideRod*2, depth], 1);
      translate([0,-(holeSpace+besideRod*2)/2, 0]) roundedRect([base, holeSpace+besideRod*2, depth], 1);
    }
    translate([centerHeight,0,-delta]) cylinder(d=rod+clearance,h=depth+delta*2);
    // pinch slot
    translate([centerHeight,-1,-delta])
      cube([rod/2+aboveRod+delta*2,2,depth+delta*2]);
    // pinch bolt
    translate([centerHeight+(rod+aboveRod)/2,-(rod+besideRod*2)/2-2,depth/2])
      rotate([-90,0,0])
        cylinder(r=2,h=rod+besideRod*2);
    translate([centerHeight+(aboveRod+rod)/2,-(rod+besideRod*2)/2,depth/2])
      rotate([-90,30,0])
        nutHole(4);
    translate([centerHeight+(aboveRod+rod)/2,rod/2+1,depth/2])
      rotate([90,30,0])
        boltHole(4);
    // base bolts
    translate([-delta, holeSpace/2, depth/2])
      rotate([0,90,0])
        cylinder(d=5, h=base+delta*2);
    translate([-delta, -holeSpace/2, depth/2])
      rotate([0,90,0])
        cylinder(d=5, h=base+delta*2);
    translate([centerHeight+rod/2+aboveRod-rackMountHole,0,-delta]) cylinder(d=4,h=depth+delta*2);
  }
}



bearing_holder();