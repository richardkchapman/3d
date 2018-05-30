include <arduino.scad>

//Arduino boards
//You can create a boxed out version of a variety of boards by calling the arduino() module
//The default board for all functions is the Uno

//Board mockups
//arduino();

dimensions = boardDimensions(UNO);
mountingHoleRadius = 3.2 / 2;
bl = 68.6;
bw = 53.5;

module base() 
{
  union() //   
   difference()
  {
    translate([0, 0, -9]) 
    	enclosure(wall=2.5,standOffHeight=2, heightExtension = 15, offset=3, mountType=PIN);
    translate([30,0,13])
      rotate([90,0,0]) cylinder(r=5,h=10, $fn=20);
    translate([7,15,11])
      cube([7.5,100,70]);
    translate([32,15,11])
      cube([13,100,70]);
  //    cube([100,100,100]);
    
  }
}

module lid() 
{
  difference()
  {
//    translate([0, 0, -8]) 
  //  	enclosure(standOffHeight=5, heightExtension = 4);
    //cube([100,100,100]);
  }

//  translate([0, 0, dimensions[2]+4 + 10]) 
  {
    difference()
    {
    	color("red")
        union()
        {
          enclosureLid(wall=2.5);
          translate([7.5,dimensions[1]-3.5,-6])
            cube([5,2.5,6]);
          translate([32.5,dimensions[1]-3.5,-6])
            cube([11,2.5,6]);
        }
      translate([-bw/100,-bl/100,-2]) 
        scale([1.02,1.02,1])
          boardShape(UNO);
//      translate([-bw/100,-bl/100,-1]) 
  //      scale([1.02,1.02,1])
    //      boardShape(UNO);
      translate([-bw/100,-bl/100,2]) 
        scale([1.02,1.02,-10])
          boardShape(UNO);
      translate([0,0,-3])
      {
        cube([28,17,5]);
        translate([45,19,0])
        {
          cube([8.5,10,5]);
          translate([4.25,4,0])
            cylinder(r=2.0,h=8,$fn=10);
        }
        translate([35,8,0])
          cylinder(r=6,h=10);
        translate([12,24.5,0])
          cube([29,37.5,7]);
      }
    }
  }
}

base();
//rotate([0,180,0])
//translate([0,0,23])
  //lid();