

c1 = [0,0];
c2 = [-5.5,2];
c3 = [0,5.5];
t = 1.2;    // plate thickness
h = 1.6;    // height of pins
delta = 0.1;
hole = 2.8;

$fn=20;

difference()
{
  union()
  {
    translate([0,0,h])
      hull()
      {
        translate(c1) cylinder(h=t, d=3.8);
        translate(c2) cylinder(h=t, d=1.5);
        translate(c3) cylinder(h=t, d=1.5);
      }

    translate(c1) cylinder(h=h, d=3.8);
    translate(c2) cylinder(h=h, d=1.5);
    translate([0,0,h+t]) translate(c3) cylinder(h=h, d=1.5);
  }
  translate([0,0,h+t-0.5])
    cylinder(d=3.8+0.2, h=0.6);
  cylinder(d=hole, h=h+t+delta);
}
