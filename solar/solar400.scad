
$fa=0.2;
$fn=0;

difference()
{
  cylinder(r=48,h=14);
  cylinder(r=46,h=12);
  cylinder(r=45.5,h=14);
  translate([-50,-20,0]) cube([100,40,14]);
  translate([-20,-50,0]) cube([40,100,14]);
}
translate([0,0,-2]) 
  difference()
  {
    cylinder(r=52,h=2);
    cylinder(r=43,h=2);
  }