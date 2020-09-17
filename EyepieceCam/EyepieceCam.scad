picamera_holespace1 = 21;
picamera_holespace2 = 12.5;
picamera_holed = 2;
mount_depth = 10;

w = 35;
h = 27;

w1 = 28;
h1 = 23   ;

w2 = 22;
h2 = 23;

rotate([-90,0,0])
difference()
{
   translate([-w/2,0,0])
     cube([w,h,mount_depth]);
  // eyepiece slot
   translate([-w1/2,0,1])
     cube([w1,h1,2]);
  // eyepiece 
   translate([-w2/2,0,0])
     cube([w2,h2,1]);
  // screw holes
   translate([-picamera_holespace1/2, 9.5,3.5])
     cylinder(r=picamera_holed/2,h=mount_depth);
   translate([picamera_holespace1/2, 9.5,3.5])
     cylinder(r=picamera_holed/2,h=mount_depth);
   translate([-picamera_holespace1/2, 9.5+picamera_holespace2,3.5])
     cylinder(r=picamera_holed/2,h=mount_depth);
   translate([picamera_holespace1/2, 9.5+picamera_holespace2,3.5])
     cylinder(r=picamera_holed/2,h=mount_depth);
   // pi camera hole
   translate([-4.5,9.5-4.5,0])
     cube([9,9,mount_depth]);
   // recess for electronics
   translate([-6,9.5-4.5+9,mount_depth-2])
     cube([12,8,2]);
  }
