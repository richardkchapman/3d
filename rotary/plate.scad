include <nutsnbolts/cyl_head_bolt.scad>;

bearingHoleSpaceY=30.5;
bearingHoleSpaceX=26;
plateThickness=8;
M5HoleRadius=5.5/2;

bearingDiameter = 26;
shaftHeight=60;
delta = 1;
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

difference()
{
  union()
  {
    roundedRect([35,100,plateThickness], 3);
    roundedRect([shaftHeight + bearingDiameter/2 + 10,40,plateThickness], 3);
  }
  translate([5,5,-delta]) cylinder(r=M5HoleRadius, h=plateThickness+delta*2);
  translate([5+bearingHoleSpaceX,5,-delta]) cylinder(r=M5HoleRadius, h=plateThickness+delta*2);
  translate([5,5+bearingHoleSpaceY,-delta]) cylinder(r=M5HoleRadius, h=plateThickness+delta*2);
  translate([5+bearingHoleSpaceX,5+bearingHoleSpaceY,-delta]) cylinder(r=M5HoleRadius, h=plateThickness+delta*2);
  translate([shaftHeight,5+bearingHoleSpaceY/2,-delta]) cylinder(r=bearingDiameter/2, h=plateThickness+delta*2);
  translate([shaftHeight,5+bearingHoleSpaceY/2-2,-delta]) cube([100,4,plateThickness+delta*2]);
  translate([shaftHeight + bearingDiameter/2 + 5,0,plateThickness/2]) rotate([-90,0,0]) cylinder(r=2,h=50);
  translate([shaftHeight + bearingDiameter/2 + 5,0,plateThickness/2]) rotate([-90,0,0]) cylinder(r=3.5,h=5);
  translate([shaftHeight + bearingDiameter/2 + 5,35,plateThickness/2]) rotate([90,0,0])   nutcatch_parallel("M4", l=5);
}
  
