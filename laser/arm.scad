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
d1 = 55;
base = 2;
sensor = 5;
fudge = 1;

module arm()
{
    
module bar() 
{
  intersection()
  {
    linear_extrude(height=h)
      hull()
      {
        translate([fullWidth/2,-l])
          circle(r=5);
        square(size=fullWidth);
      }

    // This rounds off the hinge end
    difference()
    {
      translate([0,-l-fullWidth,0])
        cube([fullWidth,l+fullWidth*2,h]);
      difference()
      {
        translate([0,fullWidth-h/2,h/2])
          cube([fullWidth,h/2,h/2]);
        difference()
        {
          translate([0,fullWidth-h/2,h/2])
            rotate([0,90,0])
              cylinder(h=fullWidth,r=h/2);
          translate([0,0,0])
            cube([fullWidth,fullWidth,h/2]);
          translate([0,0,0])
            cube([fullWidth,fullWidth-h/2,h*2]);
        }
      }
    }
  }
}

module laserMount() 
{
  translate([fullWidth/2,-l,h])
    difference()
    {
      cylinder(h=20,r=5);
      cylinder(h=21,r=3.25);
    }
}

  translate([-w/2,-w,0])
  {
    difference()
    {
      bar();
      translate([w/5,w-h,0]) cube([w/5,h,h]);
      translate([3*w/5,w-h,0]) cube([w/5,h,h]);
      translate([0,w-h/2,h/2])
        rotate([0,90,0])
          cylinder(h=fullWidth,r=pin/2);
      translate([w/2,0,0]) rotate([90,0,0]) cylinder(h=l,r=2);
      translate([w/2,-l,0])
        cylinder(h,r=2);
    }
    translate([w/2,-10,0]) cube([3,2,1]);
    translate([w/2-3,-(l-20)/4-10,0]) cube([3,2,1]);
    translate([w/2,-l/2]) cube([3,2,1]);
    translate([w/2-3,-3*(l-20)/4-10,0]) cube([3,2,1]);
    translate([w/2,-l+10,0]) cube([3,2,1]);
    laserMount();
  }
}

module hinge()
{
  translate([-w/2,-w/2,0]) difference()
  {
    intersection()
    {
      linear_extrude(height=h)
        hull()
        {
          square(size=fullWidth);
        }

      // This rounds off the hinge end
      difference()
      {
        translate([0,-l-fullWidth,0])
          cube([fullWidth,l+fullWidth*2,h]);
        difference()
        {
          translate([0,fullWidth-h/2,h/2])
            cube([fullWidth,h/2,h/2]);
          difference()
          {
            translate([0,fullWidth-h/2,h/2])
              rotate([0,90,0])
                cylinder(h=fullWidth,r=h/2);
            translate([0,0,0])
              cube([fullWidth,fullWidth,h/2]);
            translate([0,0,0])
              cube([fullWidth,fullWidth-h/2,h*2]);
          }
        }
      }
    }
    translate([0*w/5,w-h,0]) cube([w/5,h,h]);
    translate([2*w/5,w-h,0]) cube([w/5,h,h]);
    translate([4*w/5,w-h,0]) cube([w/5,h,h]);
    translate([0,w-h/2,h/2])
      rotate([0,90,0])
        cylinder(h=fullWidth,r=pin/2);
  }
}

module arca_plate(l,h=10)
{
  translate([-38/2,,0,0])
    difference()
    {
      cube([38,l,h]);
      union()
      {
        translate([-fudge,-fudge,5])
          prism(l+fudge*2, 5+fudge, 5+fudge);
        translate([-fudge,-fudge,5])
          prism(l+fudge*2, 5+fudge, -5-fudge);
        translate([38+fudge,-fudge,5])
          prism(l+fudge*2, -5-fudge, 5+fudge);
        translate([38+fudge,-fudge,5])
          prism(l+fudge*2, -5-fudge, -5-fudge);
      }
    }
}

module sensor()
{
  translate([0,-(w/4+d2/2),0])
  {
    rotate([0,0,180]) hinge();
    translate([0,w/2+d2,0]) hinge();
    translate([-d2/2-w/4,d2/2+w/4,0]) rotate([0,0,90]) hinge();
    translate([0,w/4+d2/2,0]) 
      difference()
      {
        cylinder(r=d2/2,h=flange+etube);
        translate([0,0,flange+etube-12]) rotate([0,-90,0]) cylinder(h=100,r=2); // Screw hole
        translate([0,0,base])
          cylinder(r=d1/2,h=flange+etube+fudge);  // inside
        translate([0,0,-fudge/2])
          cylinder(r=sensor/2,h=base+fudge);  // sensor hole
      }
  }
}

module mount()
{
  translate([0,0,2*w/3]) rotate([90,0,180]) hinge();
  difference ()
  {
    arca_plate(flange+etube,10);
    linear_extrude(height=30)
      hull()
      {
        translate([0,10,0]) circle(r=2.5);
        translate([0,flange+etube-10,0]) circle(r=2.5);
      }
  }
}

arm();
//sensor();
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
        translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0])
        circle(r=radius);

        translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0])
        circle(r=radius);

        translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0])
        circle(r=radius);

        translate([(x/2)-(radius/2), (y/2)-(radius/2), 0])
        circle(r=radius);
    }
}
