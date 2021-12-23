use <roundedcube.scad>

$fn=100;
plateL=40;
plateW=25;
bearingD=22.35;
bearingH=7;

module plate(l=plateL, w=plateW)
{
  difference()
  {
    union()
    {
      translate([-l/2,-w/2, 0])
        roundedcube([l,w,3], apply_to="zmax");
      cylinder(h=bearingH+1, d=25);
    }
    translate([0,0,-1])
      cylinder(h=bearingH+1, d=bearingD);
    translate([0,0,bearingH])
      cylinder(h=2, d1=bearingD, d2=bearingD-2);
  }
}

module bearing()
{
  cylinder(h=bearingH, d=bearingD);
  cylinder(h=1, d1=bearingD+2,d2=bearingD);
}

module mounting_holes()
{
  translate([0,0,-1])
  {
    translate([-plateL/2+4,-plateW/2+4,0])
      cylinder(d=3.5,h=5, $fn=20);
    translate([plateL/2-4,-plateW/2+4,0])
      cylinder(d=3.5,h=5, $fn=20);
    translate([plateL/2-4,plateW/2-4,0])
      cylinder(d=3.5,h=5, $fn=20);
    translate([-plateL/2+4,plateW/2-4,0])
      cylinder(d=3.5,h=5, $fn=20);
  }
}

difference()
{
  plate();
  bearing();
  mounting_holes();
}
