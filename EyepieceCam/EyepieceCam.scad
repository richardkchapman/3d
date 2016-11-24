picamera_holespace1 = 21;
picamera_holespace2 = 12.5;
picamera_holed = 2;
mount_depth = 10;

rotate([-90,0,0])
difference()
{
   translate([-15,0,0])
     cube([30,25,mount_depth]);
   translate([-12.1,0,1])
     cube([24.2,19,2]);
   translate([-10,0,0])
     cube([20,19,1]);
   translate([-picamera_holespace1/2, 9.5,3.5])
     cylinder(r=picamera_holed/2,h=mount_depth);
   translate([picamera_holespace1/2, 9.5,3.5])
     cylinder(r=picamera_holed/2,h=mount_depth);
   translate([-picamera_holespace1/2, 9.5+picamera_holespace2,3.5])
     cylinder(r=picamera_holed/2,h=mount_depth);
   translate([picamera_holespace1/2, 9.5+picamera_holespace2,3.5])
     cylinder(r=picamera_holed/2,h=mount_depth);
   translate([-4.5,9.5-4.5,0])
     cube([9,9,mount_depth]);
   translate([-6,9.5-4.5+9,mount_depth-2])
     cube([12,8,2]);
  }
