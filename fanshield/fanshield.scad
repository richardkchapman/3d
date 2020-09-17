/*
rotate([-90,0,0])
translate([55,-21,0])

import("/Users/rchapman/Downloads/hoodvent.stl");
*/
x = 109;  // width of opening we are blocking
y = 101;  // height of opening we are blocking
r = 45;   // radius of curves
z1 = 2;   // thickness of overlap
ac = 3;   // thickness of acrylic

z2 = ac/2; // thickness of acrylic
o = 4;     // overlap width

m = 32;    // fan mount hole spacing
f = 38;    // fan bore

hh = 20;   // central cable arch height
hw = 18;   // central cable arch width
hr = 8;    // central cable arch curve radius

shh = 20;  // side cable arch height
shw = 8;   // side cable arch width
shr = 3;   // side cable arch curve radius

trimbase = 0;  // amount to trim off base = print one at 3mm and one at 0mm
delta = 1;

module arch(x,y,z,r)
{
  cube([x,y-r,z]);
  translate([r,y-r,0])
    cylinder(z,r,r);
  translate([x-r,y-r,0])
    cylinder(z,r,r);
  translate([r,0,0])
    cube([x-2*r,y,z]);
}

difference()
{
    union()
    {
      arch(x+2*o,y+o,z1,r+o);
      translate([o,0,z1])
        arch(x,y,z2,r);
    }    
    translate([o+x/2+m/2, y-r-m/2,-delta/2])
      cylinder(z1+z2+delta,r=2.5);
    translate([o+x/2-m/2, y-r-m/2,-delta/2])
      cylinder(z1+z2+delta,r=2.5);
    translate([o+x/2+m/2, y-r+m/2,-delta/2])
      cylinder(z1+z2+delta,r=2.5);
    translate([o+x/2-m/2, y-r+m/2,-delta/2])
      cylinder(z1+z2+delta,r=2.5);
    translate([o+x/2, y-r,-delta/2])
      cylinder(z1+z2+delta,r=f/2);
    translate([o+x/2-hw/2, -delta, -delta/2])
      arch(hw,hh+delta,z1+z2+delta,hr);

    translate([o+x/4-shw/2, -delta, -delta/2])
      arch(shw,shh+delta,z1+z2+delta,shr);
    translate([o+3*x/4-shw/2, -delta, -delta/2])
      arch(shw,shh+delta,z1+z2+delta,shr);
    translate([-delta,-delta,-delta/2])
      cube([x+delta*2+o*2, trimbase+delta, z1+z2+delta]);
}

