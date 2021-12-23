// Praktica bayonet mount

pin_angle = 8;
outer_diameter = 58.6;
inner_diameter = 48;
bayonet_width = 1;

module bayonet_ramp(r=23, start = 0, angle = 10, smoothness = 0.5, h1=1, h2=2, l = 2)
{
  for (a = [0:smoothness:angle])
  {
     rotate([0,0,a+start]) rotate_extrude(angle=smoothness+0.1, convexity=2) { translate([r,0,0]) square([l,h1+a/angle*(h2-h1)]); }
  }
}

difference()
{
   union()
   {
	  // 3 bayonet lugs
      for(start = [0:120:240])
      {
          // Note we make l > bayonet_width so that it merges with body rather than sitting beside it - prints better that way
          bayonet_ramp(r=inner_diameter/2 - bayonet_width, start=start, angle=20, h1=1.4, h2=1.5, l=bayonet_width+2);
          bayonet_ramp(r=inner_diameter/2 - bayonet_width, start=start+20, angle=25, h1=1.5, h2=1.5, l=bayonet_width+2);
      }
	  // A stop column on one
      bayonet_ramp(r=inner_diameter/2 - 1, start=41, angle=4, h1=4.8, h2=4.8, l=bayonet_width+2);
   }
   // Chamfer to make it printable
   cylinder(h=1,r1=24,r2=23, $fn=100);
}

difference()
{
  // Main body
  translate([0,0,-1.75])
    cylinder(h=6.8, d=outer_diameter, $fn=100);
  // Chamfer near lens
  translate([0,0,-1.0])
    cylinder(h=1,d1=inner_diameter+2,d2=inner_diameter, $fn=100);
  // Lens contact plate
  translate([0,0,-1.75])
    cylinder(h=0.8,d=inner_diameter+2, $fn=100);
  // Central hole
  translate([0,0,-3])
    cylinder(h=10, d=inner_diameter, $fn=100);
  // Locking pin hole
  rotate([0,0,pin_angle])
    translate([27,0,-2])
      cylinder(h=10, r=1, $fn=16);
}

