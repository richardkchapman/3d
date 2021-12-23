$fn=120;
barHeight = 6;
pin=14;

function polar_to_xy(v) = [v[1] * cos(v[0]), v[1] * sin(v[0] )];

module polar_profile(control_points,step) {
/*
    control_points is an array of arrays, each of which defines a 
    point in polar cordinates [angle, radius] 
    the last angle must be the first angle + 360 for a complete profile
      e.g. [ [0,5], [130,9.9], [140,10], [350,10], [360,5] ]
    the result is a 2D profile interpolated at step degree intervals
    between these points
    by kit.wallace@gmail.com
*/
    for (angle =[0: step: 360 - 1])
    {
       ps = [angle,  lookup(angle, control_points)];
       pe = [angle+step,  lookup(angle+step, control_points) ];
       polygon ([ [0,0], polar_to_xy(ps), polar_to_xy(pe)]);
    }
}

module Cam(bar = 6)
{
  difference()
  {
    union()
    {
//    snail = [ [0,20], [90,20], [260,30], [270,30],[360,29] ];
     snail = [ [0,29], [90,30], [100,30], [270,20],[360,20] ];
      translate([0,0,0])
        cylinder(r=10, h=bar+pin);
      linear_extrude(height = bar)
        polar_profile(snail,1);
      translate([0,-10,0])
        cube([96,20,bar*.8]);
      translate([96,0,0])
        cylinder(r=10, h=bar*.8);
    }
    translate([0,0,-1])
      cylinder(r=3.5, h=bar+pin+2);
    translate([0,0,-1])
      cylinder(r=6, h=7);
  }
}

module L(bar = 6) 
{
difference()
{
  union()
  {
    translate([0,0,0])
      cylinder(r=10, h=bar+pin);
    translate([96,0,0])
      cylinder(r=10, h=bar+pin);
    translate([0,96,0])
      cylinder(r=10, h=bar+pin);
    translate([-10,0,0])
      cube([20,96,bar]);
    translate([0,-10,0])
      cube([96,20,bar]);
  }
  translate([11,11,-0.5])
    cylinder(r=1.5875,h=bar+pin+1);
}
}

module Long(bar = 6) 
{
  union()
  {
    translate([0,0,0])
      cylinder(r=10, h=bar+pin);
    translate([96,0,0])
      cylinder(r=10, h=bar+pin);
    translate([96+96,0,0])
      cylinder(r=10, h=bar+pin);
    translate([0,-10,0])
      cube([96+96,20,bar]);
  }
}

module Short(bar = 6) 
{
  union()
  {
    translate([0,0,0])
      cylinder(r=10, h=bar+pin);
    translate([96,0,0])
      cylinder(r=10, h=bar+pin);
    translate([0,-10,0])
      cube([96,20,bar]);
  }
}

module Dog(bar = 6) 
{
  difference()
  {
    union()
    {
      translate([0,0,0])
        cylinder(r=10, h=bar+pin);
      translate([0,0,0])
        cylinder(r=12.52, h=bar);
    }
    translate([10,-10,-1])
      cube([20,20,bar+2]);
  }
}

module Long2(bar = 6) 
{
  union()
  {
    translate([0,0,0])
      cylinder(r=10, h=bar+pin);
    translate([96,0,0])
      cylinder(r=10, h=bar+pin);
    translate([-48,-10,0])
      cube([96+96,20,bar]);
    translate([-48,0,0])
      cylinder(r=10,h=bar);    
    translate([96+48,0,0])
      cylinder(r=10,h=bar);    
  }
}

module template(bar = 6, pin=6) 
{
  difference()
  {
    union()
    {
      translate([0,0,0])
        cylinder(r=15, h=bar);
      translate([96,0,0])
        cylinder(r=10, h=bar+pin);
      translate([96+96,0,0])
        cylinder(r=10, h=bar+pin);
      translate([0,-10,0])
        cube([96+96,20,bar]);
    }
    translate([0,0,-1])
      cylinder(r=10, h=bar+2);
  }
}

//L(barHeight);
//translate([0,30,0])
  //Long(barHeight);
//translate([0,60,0])
  //Short(barHeight);
//translate([48,0,0])
  //Long2(barHeight);
//Dog(barHeight);
//Cam(barHeight);
template();