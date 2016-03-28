
$fa=0.2;
$fn=0;

/*                                                 -*- c++ -*-
 * A Carey mask generator.
 * Units in mm, default values are for
 * a Canon EOS 400mm
 *
 * Copyright 2013-2014, Brent Burton
 * Amended by Richard Chapman
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
gap = 3; // [3:10]

// Thickness of mask
thickness = 2; // [1:3]

// Diameter ears need to fit over
earDiameter = 90;

// Height of ears
earHeight = 14;

/* create a series of bars covering roughly one half of the
 * scope aperture. Located in the +X side.
 */
module bars(gap, width, num=5) {
    num = round(num);
    for (i=[-num:num]) {
        translate([width/2,i*2*gap]) square([width,gap], center=true);
    }
}

module careyBars(gap,width) {
    numBars = aperture/2 / gap / 2 - 1;
    // Those on the RHS are angled at 12 degrees
    intersection() {
        rotate([0,0,12]) bars(gap, width, numBars);
        square([outerDiameter/2, outerDiameter/2], center=false);
    }
    intersection() {
        rotate([0,0,-12]) bars(gap, width, numBars);
        translate([0,-outerDiameter/2]) square([outerDiameter/2, outerDiameter/2], center=false);
    }
    // And those on the LHS are angled at 10 degrees
    rotate([0,0,180]) {
        intersection() {
            rotate([0,0,10]) bars(gap, width, numBars);
            square([outerDiameter/2, outerDiameter/2], center=false);
        }
        intersection() {
            rotate([0,0,-10]) bars(gap, width, numBars);
            translate([0,-outerDiameter/2]) square([outerDiameter/2, outerDiameter/2], center=false);
        }
    }
}

module carey2D() {
    width = aperture/2;
    difference() {                          // overall plate minus center hole
        union() {
            difference() {                  // trims the mask to aperture size
                circle(r=aperture/2+1);
                careyBars(gap,width);
            }
            difference() {                  // makes the outer margin
                circle(r=outerDiameter/2-1);
                circle(r=aperture/2);
            }
            // Add horizontal and vertical structural bars:
            square([gap,2*(aperture/2+1)], center=true);
            translate([0,0]) square([aperture+1,gap], center=true);
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

// Ears to hold onto 400mm lens

difference()
{
  cylinder(r=earDiameter/2 + 2.5,h=earHeight);
  cylinder(r=earDiameter/2 + 0.5,h=earHeight-2);
  cylinder(r=earDiameter/2,h=earHeight);
  translate([-(earDiameter+10)/2,-earDiameter/4,0]) cube([earDiameter+10,earDiameter/2,earHeight]);
  translate([-earDiameter/4,-(earDiameter+10)/2,0]) cube([earDiameter/2,earDiameter+10,earHeight]);
}

// Mask
translate([0,0,-thickness]) 
   linear_extrude(height=thickness) carey2D();
