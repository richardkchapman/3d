// Praktica bayonet mount
module praktica_bayonet(h=5, od=58.6)
{
	pin_angle = 338;
	outer_diameter = od;
	inner_diameter = 48;
	bayonet_width = 1;
	delta = 0.5;  // Added to dimensions jst to make openscad render better
	
	module bayonet_ramp(r=23, start = 0, angle = 10, smoothness = 0.5, h1=1, h2=2, l = 2)
	{
	  for (a = [0:smoothness:angle])
	  {
	     rotate([0,0,a+start]) rotate_extrude(angle=smoothness+0.1, convexity=2) { translate([r,0,0]) square([l,h1+a/angle*(h2-h1)]); }
	  }
	}
	
	module PB_lugs()
	{
	  difference()
	  {
	     union()
	     {
		    // 3 bayonet lugs
	        for(start = [90:120:330])
	        {
	            // Note we make l > bayonet_width so that it merges with body rather than sitting beside it - prints better that way
	            bayonet_ramp(r=inner_diameter/2 - bayonet_width, start=start, angle=20, h1=1.4, h2=1.5, l=bayonet_width+2);
	            bayonet_ramp(r=inner_diameter/2 - bayonet_width, start=start+20, angle=25, h1=1.5, h2=1.5, l=bayonet_width+2);
	            // stop column
	            bayonet_ramp(r=inner_diameter/2 - 1, start=start+41, angle=4, h1=h-1.8, h2=h-1.8, l=bayonet_width+2);
	        }
	     }
	     // Chamfer to make it printable
	     cylinder(h=1,r1=24,r2=23, $fn=100);
	  }
	}
	
	translate([0,0,1.75])
	  PB_lugs();
	difference()
	{
	  // Main body
	  cylinder(h=h, d=outer_diameter, $fn=100);
	  // Central hole
	  translate([0,0,-delta])
	    cylinder(h=h+delta*2, d=inner_diameter, $fn=100);
	  // Make lens contact part of wall thinner
	  translate([0,0,-delta])
	    cylinder(h=0.8+delta,d=inner_diameter+2, $fn=100);
	  // and chamfer the transition so it's printable
	  translate([0,0,0.75])
	    cylinder(h=1,d1=inner_diameter+2,d2=inner_diameter, $fn=100);
	  // Locking pin hole
	  rotate([0,0,pin_angle])
	    translate([inner_diameter/2 + 3,0,-1])
	      cylinder(h=10, r=1, $fn=16);
	}
}

praktica_bayonet(h=5);