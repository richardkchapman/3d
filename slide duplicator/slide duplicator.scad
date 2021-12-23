include <threads.scad>
$fn=128;
//The diameter of the filter ring mount on the smaller lens
d1 = 64.5; //[40:120]
//The diameter of the filter ring mount on the larger lens
d2 = 67; //[40:120]

//the height of the threading for the lens
lens_thread_height = 3; //[0.5:5]

//the height of the plate
plate_height = 1; //[0.5:5]

//The thread pitch in mm
lens_pitch = 0.75; //[0.5,0.75,1.0]

insert_height=10;

inside_d = 60.5;

module lens_end()
{
difference()
{
  union()
  {
//      metric_thread(diameter = d1, pitch = lens_pitch, length=insert_height);
      cylinder(d = d1, h=insert_height);
      translate([0,0,insert_height])
         cylinder(d = d2, h=plate_height);
      translate([0,0,insert_height+plate_height])
         metric_thread(diameter = d2, pitch = lens_pitch, length=lens_thread_height);
  }
  translate([0,0,-1])
  cylinder(d = inside_d, h=lens_thread_height++insert_height+plate_height+2);
  //translate([0,0,lens_thread_height+plate_height])
  //    cylinder(d = d2-thread_wall, h=lens_thread_height);
}
}

module holder_end()
{
  difference()
  {
    union()
    {
      cylinder(h=insert_height+lens_thread_height, d=d1);
      cylinder(h=lens_thread_height, d=d2);
    }
    translate([0,0,-1])
      metric_thread(diameter = 60.5, pitch = lens_pitch, length=lens_thread_height+1);
    translate([0,0,lens_thread_height]) cylinder(h=insert_height+2, d=60);
    cylinder(h=1, d2=60.5, d1=61.5);
  }
}

//lens_end();
holder_end();