
$fa=0.2;
$fn=0;

/*                                                 -*- c++ -*-
 * A Bahtinov mask generator.
 * Units in mm, default values are for
 * a Celestron NexStar GPS 8.
 *
 * Copyright 2013-2014, Brent Burton
 * License: CC-BY-SA
 *
 * Updated: 2014-06-23
 */

// This is the diameter of the mask.
outerDiameter = 102; // [80:400]

// The telescope light's path diameter.
aperture = 86; // [80:400]

// Diameter of secondary mirror holder. If no secondary, set to 0.
centerHoleDiameter = 0; // [0:90]

// Width of the gaps and the bars.
gap = 4; // [4:10]

/* create a series of bars covering roughly one half of the
 * scope aperture. Located in the +X side.
 */
module bars(gap, width, num=5) {
    num = round(num);
    for (i=[-num:num]) {
        translate([width/2,i*2*gap]) square([width,gap], center=true);
    }
}

module bahtinovBars(gap,width) {
    numBars = aperture/2 / gap / 2 -1;
    // +X +Y bars
    intersection() {
        rotate([0,0,30]) bars(gap, width, numBars);
        square([outerDiameter/2, outerDiameter/2], center=false);
    }
    // +X -Y bars
    intersection() {
        rotate([0,0,-30]) bars(gap, width, numBars);
        translate([0,-outerDiameter/2]) square([outerDiameter/2, outerDiameter/2], center=false);
    }
    // -X bars
    rotate([0,0,180]) bars(gap, width, numBars);
}

module bahtinov2D() {
    width = aperture/2;
    difference() {                          // overall plate minus center hole
        union() {
            difference() {                  // trims the mask to aperture size
                circle(r=aperture/2+1);
                bahtinovBars(gap,width);
            }
            difference() {                  // makes the outer margin
                circle(r=outerDiameter/2-1);
                circle(r=aperture/2);
            }
            // Add horizontal and vertical structural bars:
            square([gap,2*(aperture/2+1)], center=true);
            translate([aperture/4,0]) square([aperture/2+1,gap], center=true);
            // Add center hole margin if needed:
            if (centerHoleDiameter > 0 && centerHoleDiameter < outerDiameter) {
                circle(r=(centerHoleDiameter+gap)/2);
            }
        }
        // subtract center hole if needed
        if (centerHoleDiameter > 0 && centerHoleDiameter < outerDiameter) {
            circle(r=centerHoleDiameter/2+1);
        }
    }
}

difference()
{
  cylinder(r=47.5,h=14);
  cylinder(r=45.5,h=12);
  cylinder(r=45,h=14);
  translate([-50,-20,0]) cube([100,40,14]);
  translate([-20,-50,0]) cube([40,100,14]);
}
translate([0,0,-2]) 
   linear_extrude(height=2) bahtinov2D();
// difference()
// { 
//   cylinder(r=51,h=2);
//    cylinder(r=43,h=2);
// }

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