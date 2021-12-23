module RF_lens(height=3, od=64.7, id=42.7)
{
	RF_diameter = 53.7;
	lug_height = 4.2;
	lug_thickness = 1.5;
	lug_length = 2.75;
	
	t = (od-RF_diameter) / 2;
	t2 = (RF_diameter-id) / 2;
	
	$fn = 100;
	delta = 0.1;
	
	hole_depth=3;
	hole_diameter=3;
	
	support = 0;
	
	module bayonet_ramp(r=23, start = 0, angle = 10, smoothness = 0.5, h1=1, h2=2, l = 2, z = 0)
	{
	  translate([0,0,z])
	  for (a = [0:smoothness:angle])
	  {
	     rotate([0,0,a+start]) rotate_extrude(angle=smoothness+0.1, convexity=2) { translate([r,0,0]) square([l,h1+a/angle*(h2-h1)]); }
	  }
	  if (z>0 && support > 0)
	  for (a = [0:8:angle])
	  {
	     rotate([0,0,a+start]) rotate_extrude(angle=support, convexity=2) { translate([r+l-0.8,0,0]) square([0.8,z-delta]); }
	  }
	}
	
    rotate([0,0,90])
    {
		translate([0,0,-height])
		 difference()
		 {
		  cylinder(h=height, d = RF_diameter + t*2);
		  translate([0,0,-delta]) cylinder(h=height+delta*2, d = RF_diameter - t2*2);
		  hull()
		  {
		    translate([0, RF_diameter/2+t/2-0.5, height-hole_depth]) cylinder(h=hole_depth+delta, d=hole_diameter);
		    translate([0, RF_diameter/2+t/2+0.5, height-hole_depth]) cylinder(h=hole_depth+delta, d=hole_diameter);
		  }
		 }
		
		difference()
		{
		  union()
		  {
		    cylinder(h=1.5,d=RF_diameter);
		    cylinder(h=lug_height+lug_thickness, d = RF_diameter-lug_length);
		  }
		  translate([0,0,-delta]) cylinder(h=lug_height+lug_thickness+delta*2, d = RF_diameter - t2*2);
		}
		
		{
		  bayonet_ramp(r=(RF_diameter/2)-lug_length-delta, l=lug_length+delta, h1=lug_thickness, h2=lug_thickness, start=-20, angle=50, z=lug_height);
		  bayonet_ramp(r=(RF_diameter/2)-lug_length-delta, l=lug_length+delta, h1=lug_thickness, h2=lug_thickness, start=130, angle=60, z=lug_height);
		  bayonet_ramp(r=(RF_diameter/2)-lug_length-delta, l=lug_length+delta, h1=lug_thickness, h2=lug_thickness, start=240, angle=50, z=lug_height);
		}
		bayonet_ramp(r=(RF_diameter/2)-lug_length-delta, l=lug_length+delta, h1=lug_height+lug_thickness, h2=lug_height+lug_thickness, start=130, angle=3);
    }
}

RF_lens();