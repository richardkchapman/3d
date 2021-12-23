include <threads.scad>
$fn=128;
//The diameter of the filter ring mount on the smaller lens
d1 = 40.5; //[40:120]
//The diameter of the filter ring mount on the larger lens
d2 = 71.4; //[40:120]

//the height of the threading for the lens
lens_thread_height = 3; //[0.5:5]

//the height of the plate
plate_height = 1; //[0.5:5]

//The thread pitch in mm
lens_pitch = 0.75; //[0.5,0.75,1.0]

//The thread pitch in mm of the lens 
thread_wall=4;

difference()
{
  union()
  {
      metric_thread(diameter = d1, pitch = lens_pitch, length=lens_thread_height);
      translate([0,0,lens_thread_height])
         cylinder(d = d2, h=plate_height);
      translate([0,0,lens_thread_height+plate_height])
         metric_thread(diameter = d2, pitch = lens_pitch, length=lens_thread_height);
  }
  cylinder(d = d1-thread_wall, h=lens_thread_height*2+plate_height);
  //translate([0,0,lens_thread_height+plate_height])
  //    cylinder(d = d2-thread_wall, h=lens_thread_height);
}
