xSpace=22.2;
ySpace=10.3;
minY=6.4;
border=6;
slot=3;

difference()
{
  union()
  {
    cube([4,xSpace+border*2,19+slot]);
    cube([10,xSpace+border*2,4]);
  }
  translate([7,border,-1])
    cylinder(h=7,d=3, $fn=24);
  translate([7,border,2.5])
    cylinder(h=2,d1=3,d2=6, $fn=24);
  translate([7,xSpace+border,-1])
    cylinder(h=7,d=3, $fn=24);
  translate([7,xSpace+border,2.5])
    cylinder(h=2,d1=3,d2=6, $fn=24);
  translate([-1,border,minY])
    rotate([0,90,0])
      hull()
      {
        cylinder(h=7,d=3, $fn=24);
        translate([-slot,0,0]) cylinder(h=7,d=3, $fn=24);
      }
  translate([-1,border+xSpace,minY+ySpace])
    rotate([0,90,0])
      hull()
      {
        cylinder(h=7,d=3, $fn=24);
        translate([-slot,0,0]) cylinder(h=7,d=3, $fn=24);
      }
}