
$fa=0.2;
$fn=0;

difference()
{
  cylinder(r=47.5,h=14);
  cylinder(r=45.5,h=12);
  cylinder(r=45,h=14);
  translate([-50,-20,0]) cube([100,40,14]);
  translate([-20,-50,0]) cube([40,100,14]);
}
translate([0,0,-2]) 
  difference()
  {
    translate([-52,-52,0]) cube([104,104,2]);
    cylinder(r=43,h=2);
  }

/*
translate([0,0,-10])  
{
  difference()
  {
    translate([-52,-52,0]) cube([104,104,2]);
    cylinder(r=43,h=2);
  }
  translate([-54,-30,0]) 
    union()
    {
       cube([2,10,5]);
       translate([0,0,4]) cube([2.5,10,2]);
    }
  translate([-54,20,0]) 
    union()
    {
       cube([2,10,5]);
       translate([0,0,4]) cube([2.5,10,2]);
    }
  translate([52,-30,0])
    union()
    {
       cube([2,10,5]);
       translate([-0.5,0,4]) cube([2.5,10,2]);
    }
  translate([52,20,0])
    union()
    {
       cube([2,10,5]);
       translate([-0.5,0,4]) cube([2.5,10,2]);
    }
  translate([-30,-54,0])
    union()
    {
       cube([10,2,5]);
       translate([0,0,4]) cube([10,2.5,2]);
    }
  translate([20,-54,0])
    union()
    {
       cube([10,2,5]);
       translate([0,0,4]) cube([10,2.5,2]);
    }
  translate([-30,52,0])
    union()
    {
       cube([10,2,5]);
       translate([0,-0.5,4]) cube([10,2.5,2]);
    }
  translate([20,52,0])
    union()
    {
       cube([10,2,5]);
       translate([0,-0.5,4]) cube([10,2.5,2]);
    }
}
*/