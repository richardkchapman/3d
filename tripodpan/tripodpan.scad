// OpenSCAD Herringbone Wade's Gears Script
// (c) 2011, Christopher "ScribbleJ" Jansen
//
// Thanks to Greg Frost for his great "Involute Gears" script.
//
// Licensed under the BSD license.
include <MCAD/involute_gears.scad> 
include <MCAD/stepper.scad> 

$fn=100;

// WHAT TO GENERATE?
//generate = 0;    // Generate everything for viewing
// generate = 1;    // Generate stepper 1 gear
// generate = 2;    // Generate large tripod gear
 generate = 3;    // Generate ball head motor mount
// generate = 4;    // generate gear 1 for sidekick
// generate = 5;    // generate gear 2 for sidekick
//generate = 6;    // generate sidekick motor mount

// Tripod dimensions
plate_thickness = 2;
tripod_head_d = 74;
tripod_bolt_d = 10;
tripod_head_small_d = 64;

// Sidekick dimensions
shaft_d1 = 39;
shaft_d2 = 32;
plate_hole_sep = 51.5;
plate_hole_d = 7;
bolt_head_h = 6.3;
bolt_head_d = 10.5;


// Nema mount
mount_wall = 3;
mount_total_height = 35;
mount_base = 5;

NemaSideSize = 43.5;   // Allow a bit of tolerance
NemaDistanceBetweenMountingHoles =  31.04;
NemaMountingHoleDiameter = 4;
NemaRoundExtrusionDiameter = 24;  // 22 in theory but give some clearance
NemaShaftHole = 6;  // 5.5 would do but give some clearance
NemaRoundExtrusionHeight = 2;
NemaCornerChamfer = 2;

// OPTIONS COMMON TO BOTH GEARS:
distance_between_axels = tripod_head_small_d/2+NemaSideSize/2+mount_wall;
distance_between_axels2 = shaft_d1/2+NemaSideSize/2+mount_wall;
gear_h = 10;
gear_shaft_h = 10;

// The stepper motor needs between 20-27mm from tripod head body, 
// and head body diameter is about 64mm diameter (32mm radius), so 
// distance between centers needs to be between 52 and 60mm

// GEAR1 (SMALLER GEAR, STEPPER GEAR) OPTIONS:
// It's helpful to choose prime numbers for the gear teeth.
gear1_teeth = 13;
gear3_teeth = 13;
gear1_shaft_d = 5.25;  			// diameter of motor shaft
gear1_shaft_r  = gear1_shaft_d/2;	
// gear1 shaft assumed to fill entire gear.
// gear1 attaches by means of a captive nut and bolt (or actual setscrew)
gear1_setscrew_offset = 5;			// Distance from motor on motor shaft.
gear1_setscrew_d         = 3.5;		
gear1_setscrew_r          = gear1_setscrew_d/2;
gear1_captive_nut_d = 6.2;
gear1_captive_nut_r  = gear1_captive_nut_d/2;
gear1_captive_nut_h = 3;

// GEAR2 (LARGER GEAR, DRIVE SHAFT GEAR) OPTIONS:
gear2_teeth = 51;
gear4_teeth = 39;

// Tolerances for geometry connections.
AT=0.02;
ST=AT*2;
TT=AT/2;

module gearsbyteethanddistance(t1=13,t2=51, d=60, teethtwist=1,which=1,head_d=0,plate_thickness=plate_thickness,holes=0)
{
	cp = 360*d/(t1+t2);

	g1twist = 200 / t1;
	g2twist = 200 / t2;

	g1p_d  =  t1 * cp / 180;
	g2p_d  =  t2 * cp / 180;
	g1p_r   = g1p_d/2;
	g2p_r   = g2p_d/2;

	echo(str("Your small ", t1, "-toothed gear will be ", g1p_d, "mm across (plus 1 gear tooth size) (PR=", g1p_r,")"));
	echo(str("Your large ", t2, "-toothed gear will be ", g2p_d, "mm across (plus 1 gear tooth size) (PR=", g2p_r,")"));
	echo(str("Your gear mount axles should be ", d,"mm (", g1p_r+g2p_r,"mm calculated) from each other."));
	if(which == 1)
	{
		// GEAR 1
		difference()
		{
		union()
		{
			translate([0,0,(gear_h/2) - TT])
				gear(	twist = g1twist, 
					number_of_teeth=t1, 
					circular_pitch=cp, 
					gear_thickness = gear_shaft_h + (gear_h/2)+AT, 
					rim_thickness = (gear_h/2)+AT, 
					rim_width = 0,
					hub_thickness = (gear_h/2)+AT, 
					hub_width = 0,
					bore_diameter=0); 
	
			translate([0,0,(gear_h/2) + AT])
			rotate([180,0,0]) 
				gear(	twist = -g1twist, 
					number_of_teeth=t1, 
					circular_pitch=cp, 
					gear_thickness = (gear_h/2)+AT, 
					rim_thickness = (gear_h/2)+AT, 
					hub_thickness = (gear_h/2)+AT, 
					bore_diameter=0); 
		}
			//DIFFERENCE:
			//shafthole
			translate([0,0,-TT]) 
				cylinder(r=gear1_shaft_r, h=gear_h+gear_shaft_h+ST);

			//setscrew shaft
			translate([0,0,gear_h+gear_shaft_h-gear1_setscrew_offset])
				rotate([0,90,0])
				cylinder(r=gear1_setscrew_r, h=g1p_r);

			//setscrew captive nut
			translate([(g1p_r)/2, 0, gear_h+gear_shaft_h-gear1_captive_nut_r-gear1_setscrew_offset]) 
				translate([0,0,(gear1_captive_nut_r+gear1_setscrew_offset)/2])
					#cube([gear1_captive_nut_h, gear1_captive_nut_d, gear1_captive_nut_r+gear1_setscrew_offset+ST],center=true);
		}
	}
	else
	{
		// GEAR 2 
		difference()
		{
 		union()
		{
			translate([0,0,(gear_h/2) - TT])
				gear(	twist = -g2twist, 
					number_of_teeth=t2, 
					circular_pitch=cp, 
					gear_thickness =  (gear_h/2)+AT, 
					rim_thickness = (gear_h/2)+AT, 
					hub_thickness = 0,
          circles = holes,
					bore_diameter=tripod_bolt_d); 

			translate([0,0,(gear_h/2) + AT])
			rotate([180,0,0]) 
				gear(	twist = g2twist, 
					number_of_teeth=t2, 
					circular_pitch=cp, 
					gear_thickness = (gear_h/2)+AT, 
					rim_thickness = (gear_h/2)+AT, 
					hub_thickness = 0,
          circles = holes,
					bore_diameter=tripod_bolt_d); 

    }
  	//DIFFERENCE:
    translate([0,0,plate_thickness])
      cylinder(r=head_d/2, h=gear_h+AT);
		}
	}
}

t1 = gear1_teeth;
t2 = gear2_teeth;
cp = 360*distance_between_axels/(t1+t2);
g1p_d  =  t1 * cp / 180;
g2p_d  =  t2 * cp / 180;
g1p_r   = g1p_d/2;
g2p_r   = g2p_d/2;

t3 = gear3_teeth;
t4 = gear4_teeth;
cp2 = 360*distance_between_axels2/(t3+t4);
g3p_d  =  t3 * cp2 / 180;
g4p_d  =  t4 * cp2 / 180;
g3p_r   = g3p_d/2;
g4p_r   = g4p_d/2;

if(generate == 1)
{
	gearsbyteethanddistance(t1 = gear1_teeth, t2=gear2_teeth, d=distance_between_axels, which=1);
}
else if(generate == 2)
{
  	gearsbyteethanddistance(t1 = gear1_teeth, t2=gear2_teeth, d=distance_between_axels, which=2, head_d=tripod_head_d, holes=4);
}
else if (generate==3)
{
  nemaMount(tripod_head_small_d, distance_between_axels);
}
else if (generate == 4)
{
	gearsbyteethanddistance(t1 = gear3_teeth, t2=gear4_teeth, d=distance_between_axels2, which=1);
}
else if(generate == 5)
{
  difference()
  {
  	gearsbyteethanddistance(t1 = gear3_teeth, t2=gear4_teeth, d=distance_between_axels2, which=3, head_d=shaft_d1,plate_thickness=0);
    translate([0,plate_hole_sep/2,-AT])
    {
      cylinder(r=plate_hole_d/2,h=gear_h+ST);
      translate([0,0,gear_h-bolt_head_h])
        cylinder(r=bolt_head_d/2,h=gear_h+ST);
    }
    translate([0,-plate_hole_sep/2,-AT])
    {
      cylinder(r=plate_hole_d/2,h=gear_h+ST);
      translate([0,0,gear_h-bolt_head_h])
        cylinder(r=bolt_head_d/2,h=gear_h+ST);
    }
  }
}
else if (generate==6)
{
  nemaMount(shaft_d2, distance_between_axels2);
}
else if (generate==0)
{
	translate([0,g2p_r+g1p_r,0]) rotate([0,0,($t*360/gear1_teeth)]) gearsbyteethanddistance(t1 = gear1_teeth, t2=gear2_teeth, d=distance_between_axels, which=1);
	translate([0,0,0])  rotate([0,0,($t*360/gear2_teeth)*-1]) gearsbyteethanddistance(t1 = gear1_teeth, t2=gear2_teeth, d=distance_between_axels, which=2,head_d=tripod_head_d, holes=4);
  translate([0,0,gear_h+gear_shaft_h+5])
    nemaMount(tripod_head_small_d, distance_between_axels);
  translate([0,0,plate_thickness])
    color([0,0,0])
      cylinder(r=tripod_head_small_d/2,h=gear_h+gear_shaft_h+5+mount_total_height+10);
  
  translate([0,150,0])
  {
  	translate([0,g4p_r+g3p_r,0])
      rotate([0,0,($t*360/gear3_teeth)])
        gearsbyteethanddistance(t1 = gear3_teeth, t2=gear4_teeth, d=distance_between_axels2, which=1);
    translate([0,0,0])  
      rotate([0,0,($t*360/gear4_teeth)*-1]) 
        difference()
        {
          gearsbyteethanddistance(t1=gear3_teeth, t2=gear4_teeth, d=distance_between_axels2, which=2,head_d=shaft_d1);
          translate([plate_hole_sep/2,0,-AT])
            cylinder(r=plate_hole_d/2,h=gear_h+ST);
          translate([-plate_hole_sep/2,0,-AT])
            cylinder(r=plate_hole_d/2,h=gear_h+ST);
        }
    translate([0,0,gear_h+gear_shaft_h+5])
      nemaMount(shaft_d2, distance_between_axels2);
  }
}

module nemaMount(body_rad, centers, wings=false)
{
  difference()
  {
    translate([-(NemaSideSize+mount_wall*2)/2,0,0])
      cube([NemaSideSize+mount_wall*2, centers+NemaSideSize/2,mount_total_height]);
    cylinder(r=body_rad/2,h=mount_total_height);
    translate([-NemaSideSize/2,centers-NemaSideSize/2,mount_base])
      difference()
      {
        cube([NemaSideSize,NemaSideSize,mount_total_height]);
        rotate([90,0,90])
          prism(mount_total_height, NemaCornerChamfer, NemaCornerChamfer);
        translate([NemaSideSize,0,0])
          rotate([90,0,180])
            prism(mount_total_height, NemaCornerChamfer, NemaCornerChamfer);
        translate([0,NemaSideSize,0])
          rotate([90,0,0])
            prism(mount_total_height, NemaCornerChamfer, NemaCornerChamfer);
        translate([NemaSideSize,NemaSideSize,0])
          rotate([90,0,-90])
            prism(mount_total_height, NemaCornerChamfer, NemaCornerChamfer);
      }
    translate([-(NemaSideSize+mount_wall*2)/2,centers+NemaSideSize/2,mount_total_height+mount_base])
      translate([-AT,0,0])
        rotate([90,90,0])
          prism(NemaSideSize+mount_wall*2+ST,mount_total_height,NemaSideSize);
    translate([0,centers,mount_base-NemaRoundExtrusionHeight])
      cylinder(r=NemaRoundExtrusionDiameter/2,h=NemaRoundExtrusionHeight+AT);
    translate([0,centers,-AT])
      cylinder(r=NemaShaftHole/2,h=mount_base+ST);
    translate([NemaDistanceBetweenMountingHoles/2,centers-NemaDistanceBetweenMountingHoles/2,0])
      cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
    translate([-NemaDistanceBetweenMountingHoles/2,centers-NemaDistanceBetweenMountingHoles/2,0])
      cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
    translate([NemaDistanceBetweenMountingHoles/2,centers+NemaDistanceBetweenMountingHoles/2,0])
      cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
    translate([-NemaDistanceBetweenMountingHoles/2,centers+NemaDistanceBetweenMountingHoles/2,0])
      cylinder(r=NemaMountingHoleDiameter/2,h=mount_total_height);
  }
  if (NemaSideSize+mount_wall*2 > body_rad)
  {
    wing_height=20;
    difference()
    {
      union()
      {
        translate([-(NemaSideSize+mount_wall*2)/2, -20, 0])
          cube([(NemaSideSize+mount_wall*2-body_rad)/2,wing_height,mount_total_height]);
        translate([body_rad/2, -20, 0])
          cube([(NemaSideSize+mount_wall*2-body_rad)/2,wing_height,mount_total_height]);
      }
      translate([-(NemaSideSize+mount_wall*2)/2,-wing_height/2,mount_total_height/2])
        rotate([0,90,0])
          cylinder(r=3/2,h=NemaSideSize+mount_wall*2);
    }
  }
  else
  {
    difference()
    {
      cylinder(r=body_rad/2+10,h=mount_total_height);
      cylinder(r=body_rad/2,h=mount_total_height);
      translate([-(NemaSideSize+mount_wall*2)/2,0,0])
        cube([NemaSideSize+mount_wall*2, body_rad/2+mount_wall+NemaSideSize,mount_total_height]);
      translate([-(body_rad/2+10),-(body_rad/2+10),0])
        cube([body_rad+20,(body_rad/2+10),mount_total_height]);
      // "Donut holes" for wire attachment
      translate([body_rad/2+10,0,mount_total_height/5])
        rotate_extrude()
          translate([5, 0, 0])
            circle(r = 2);
      translate([body_rad/2+10,0,mount_total_height/2])
        rotate_extrude()
          translate([5, 0, 0])
            circle(r = 2);
      translate([body_rad/2+10,0,4*mount_total_height/5])
        rotate_extrude()
          translate([5, 0, 0])
            circle(r = 2);
      translate([-body_rad/2-10,0,mount_total_height/5])
        rotate_extrude()
          translate([5, 0, 0])
            circle(r = 2);
      translate([-body_rad/2-10,0,mount_total_height/2])
        rotate_extrude()
          translate([5, 0, 0])
            circle(r = 2);
      translate([-body_rad/2-10,0,4*mount_total_height/5])
        rotate_extrude()
          translate([5, 0, 0])
            circle(r = 2);
    }
  }
}



//Draw a prism based on a 
//right angled triangle
//l - length of prism
//w - width of triangle
//h - height of triangle
module prism(l, w, h) {
       polyhedron(points=[
               [0,0,h],           // 0    front top corner
               [0,0,0],[w,0,0],   // 1, 2 front left & right bottom corners
               [0,l,h],           // 3    back top corner
               [0,l,0],[w,l,0]    // 4, 5 back left & right bottom corners
       ], faces=[ // points for all faces must be ordered clockwise when looking in
               [0,2,1],    // top face
               [3,4,5],    // base face
               [0,1,4,3],  // h face
               [1,2,5,4],  // w face
               [0,3,5,2],  // hypotenuse face
       ]);
}


