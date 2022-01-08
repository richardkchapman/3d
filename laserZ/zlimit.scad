difference()
{
  cube([20,8,10]);
  translate([5,4,-1])
  {
     cylinder(h=12,d=3, $fn=36);
     cylinder(h=6,d=4.5, $fn=36);
  }
  translate([15,4,-1])
  {
     cylinder(h=12,d=3, $fn=36);
     cylinder(h=6,d=4.5, $fn=36);
  }
  translate([2,-1,5])
    rotate([-90,0,0]) cylinder(h=10,d=2, $fn=36);
  translate([20-2,-1,5])
    rotate([-90,0,0]) cylinder(h=10,d=2, $fn=36);
}
