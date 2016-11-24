include <nutsnbolts/cyl_head_bolt.scad>;

$fn=50;

//roundedRect([10,150,5], 3);

fullWidth = 20;
w = fullWidth;
h = 8;
l = 180;
pin=4;
flange = 44;
etube = 10;
d2 = 65;
d1 = 56.5;
holed = 60;  // Diameter of flange mounting holes
transD = 4.8;  // Diameter of phototransistor
base = 2;
sbase = 3;
sensor = 20;  // Make it oversize so we can use ground-glass focussing screen
fudge = 1;
hingeTol = 0.2; // tightness of fit
hingeGap = 2;   // Extra length on arms
sensorTol = 0.5; // tightness of fit

module triPlate(w=fullWidth,holesize=3,c=false)
{
    difference()
    {
        cylinder(h/2,r=w/2);
        rotate([0,0,0])
          translate([0,-w/2+3,0])
            cylinder(h/2,r=holesize/2);
        rotate([0,0,-120])
          translate([0,-w/2+3,0])
            cylinder(h/2,r=holesize/2);
        rotate([0,0,120])
          translate([0,-w/2+3,0])
            cylinder(h/2,r=holesize/2);
        if (c)
          cylinder(h/2,r=1.5);
    }
}

module laserMount() 
{
  difference()
  {
    union()
    {
      triPlate(c=true);
      translate([0,0,h/2])
        cylinder(h=27-h/2,r=6);
    }
    cylinder(h=28,r=4.25);  // Should be 8mm/2 but holes seem to print smaller than you ask
    //translate([-4.5,-1.25,0])
      //cube([9,2.5,13]);
    translate([0,0,21])
      rotate([90,0,0]) 
        cylinder(h=10,r=1.5);
  }
}

module arm()
{
  difference()
  {
    linear_extrude(height=h/2)
      hull()
      {
        translate([fullWidth/2,-l])
          circle(r=5);
        square(size=[fullWidth,1]);
      }
    translate([w/2,-l,0])
      triPlate();
  }
  translate([w/2,w/2]) hinge(pins=3);
  translate([w/2-w/10,-l+w])
  {
    cube([w/5,l-w,h]);
    translate([0,0,h/2])
      rotate([0,0,-90])
        prism(w/5,w/2,h/2);
  }
  intersection()
  {
    linear_extrude(height=h)
      hull()
      {
        translate([fullWidth/2,-l])
          circle(r=5);
        square(size=[fullWidth,1]);
      }
    translate([0,0,h/2])
      rotate([0,0,-90])
        prism(w,w,h/2);
  }
  translate([w/2,-l,0])
    triPlate(holesize=3.5);
}

module hinge(pins=2)
{
  translate([-w/2,-w/2,0]) 
  {
    intersection()
    {
      union()
      {
        difference()
        {
          linear_extrude(height=h)
            hull()
            {
              square(size=fullWidth);
            }
          if (pins==2)
          {
            translate([0*w/5,w-h-hingeGap,0]) cube([w/5+hingeTol,h+hingeGap,h]);
            translate([2*w/5,w-h-hingeGap,0]) cube([w/5+hingeTol,h+hingeGap,h]);
            translate([4*w/5,w-h-hingeGap,0]) cube([w/5+hingeTol,h+hingeGap,h]);
          } else {
            translate([1*w/5,w-h-hingeGap,0]) cube([w/5+hingeTol,h+hingeGap,h]);
            translate([3*w/5,w-h-hingeGap,0]) cube([w/5+hingeTol,h+hingeGap,h]);
          }
          translate([0,w-h/2,h/2])
            rotate([0,90,0])
              cylinder(h=fullWidth,r=pin/2);
        }
        if (false)  // if (pins==3) - nut trap, didn't really work
        {
          difference()
          {
            translate([w,w/2,0])
              cube([6,w/2,h]);
            translate([w,w-h/2,h/2])
              rotate([0,-90,0])
                nutcatch_sidecut("M4", l=10, clk=0.1, clh=0.1, clsl=0.1);
          }
        }
      }
      // This rounds off the hinge end
      difference()
      {
        translate([0,-l-fullWidth,0])
          cube([fullWidth+6,l+fullWidth*2,h]);
        difference()
        {
          translate([0,fullWidth-h/2,h/2])
            cube([fullWidth+6,h/2,h/2]);
          difference()
          {
            translate([0,fullWidth-h/2,h/2])
              rotate([0,90,0])
                cylinder(h=fullWidth+6,r=h/2);
            translate([0,0,0])
              cube([fullWidth+6,fullWidth,h/2]);
            translate([0,0,0])
              cube([fullWidth+6,fullWidth-h/2,h*2]);
          }
        }
      }
    }
  }
}

module arca_plate(l,h=10)
{
  // Specs suggest 38mm is the width, as do measurements,
  // but when I printed at 38mm it came out too narrow to be gripped..
  width = 41;
  translate([-width/2,,0,0])
    difference()
    {
      cube([width,l,h]);
      union()
      {
        translate([-fudge,-fudge,h/2])
          prism(l+fudge*2, h/2+fudge, h/2+fudge);
        translate([-fudge,-fudge,h/2])
          prism(l+fudge*2, h/2+fudge, -h/2-fudge);
        translate([width+fudge,-fudge,h/2])
          prism(l+fudge*2, -h/2-fudge, h/2+fudge);
        translate([width+fudge,-fudge,h/2])
          prism(l+fudge*2, -h/2-fudge, -h/2-fudge);
      }
    }
}

module sensor()
{
  translate([0,-(w/4+d2/2),0])
  {
    // Hinges for laser arms
    rotate([0,0,180]) hinge();
    translate([0,w/2+d2,0]) hinge();
    // Hinge for tripod mount
    translate([-d2/2-w/4,d2/2+w/4,0]) rotate([0,0,90]) hinge(pins=3);
    translate([0,w/4+d2/2,0]) 
      difference()
      {
        cylinder(r=d2/2,h=flange+etube);
        translate([0,0,flange+etube-12]) rotate([0,-90,0]) cylinder(h=100,r=2); // Screw hole
        translate([0,0,base])
          cylinder(r=d1/2,h=flange+etube+fudge);  // inside
        translate([0,0,-fudge/2])
          cylinder(r=sensor/2,h=base+fudge);  // sensor hole
        // Screw holes
        rotate([0,0,45])
        {
          translate([0,holed/2,flange+etube-5])
            cylinder(r=0.5,h=5);  // screw holes
          translate([0,-holed/2,flange+etube-5])
            cylinder(r=0.5,h=5);  // screw holes
          translate([holed/2,0,flange+etube-5])
            cylinder(r=0.5,h=5);  // screw holes
          translate([-holed/2,0,flange+etube-5])
            cylinder(r=0.5,h=5);  // screw holes
        }
      }
  }
}

studDiameter=5;
studClearance=0.1;
studHeight=sbase;

module stud_pin()
{
  difference()
  {
    union()
    {
      cylinder(r=studDiameter/2 - studClearance, h=studHeight);
      translate([0,0,studHeight*0.75]) 
        cylinder(h=studHeight*0.25, r2=studDiameter/2 - studClearance, r=studDiameter/2 + 0.25);
    }
    translate([0,0,studHeight*5/6]) cube([1.5,8,studHeight],true);
  }
}

module stud_hole()
{
    union()
    {
      cylinder(r=studDiameter/2,h=studHeight);
      translate([0,0,studHeight/2]) 
        cylinder(r=studDiameter/2 +1,h=studHeight);
    }
}

module subsensor()
{
  difference()
  {
    union()
    {
      translate([0,0,sbase]) cylinder(r=sensor/2-sensorTol,h=base);  // sensor hole
      cylinder(r=d2/2,h=sbase);  // sensor hole
      translate([-w/2,-(d2+15)/2,0]) cube([w,d2+15,sbase]);
    }
    translate([-3,-3,0])
      cube([6,6,base+sbase]);
    translate([15,15,0])
      stud_hole();
    translate([15,-15,0])
      stud_hole();
    translate([-15,15,0])
      stud_hole();
    translate([-15,-15,0])
      stud_hole();
  }
}

module subsensor_cap()
{
  union()
  {
    translate([-20,-20,0])
      cube([40,40,sbase]);
    translate([0,0,sbase])
    {
      translate([-20,-20,0])
        cube([12.5,40,8]);
      translate([7.5,-20,0])
        cube([12.5,40,8]);
    }
    translate([0,0,sbase+8])
    {
      translate([15,15,0])
        stud_pin();
      translate([15,-15,0])
        stud_pin();
      translate([-15,15,0])
        stud_pin();
      translate([-15,-15,0])
        stud_pin();
    }
  }
}

module mount()
{
  translate([0,0,2*w/3]) rotate([90,0,180]) hinge();
  difference ()
  {
    arca_plate(flange+etube,8);
    linear_extrude(height=30)
      hull()
      {
        translate([0,10,0]) circle(r=2.5);
        translate([0,flange+etube-10,0]) circle(r=2.5);
      }
  }
}

laserMount();
//arm();
//sensor();
//subsensor();
//subsensor_cap();
//mount();

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

module roundedRect(size, radius)
{
    x = size[0];
    y = size[1];
    z = size[2];
    linear_extrude(height=z)
    hull()
    {
        // place 4 circles in the corners, with the given radius
        translate([(radius/2), (radius/2), 0])
        circle(r=radius);

        translate([x-(radius/2), (radius/2), 0])
        circle(r=radius);

        translate([(radius/2), y-(radius/2), 0])
        circle(r=radius);

        translate([x-(radius/2), y-(radius/2), 0])
        circle(r=radius);
    }
}

