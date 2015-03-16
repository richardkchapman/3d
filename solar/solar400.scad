
difference()
{
  cylinder(r=48,h=10);
  cylinder(r=45,h=9);
  cylinder(r=44,h=10);
  translate([-50,-10,0]) cube([100,20,10]);
  translate([-10,-50,0]) cube([20,100,10]);
}
translate([0,0,-1]) 
  difference()
  {
    cylinder(r=52,h=1);
    cylinder(r=45,h=1);
  }