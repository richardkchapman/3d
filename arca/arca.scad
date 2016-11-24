$fn=50;

fudge = 1;    // Used to oversize some shapes being subtracted to help make things look better
width = 41;   // Specs suggest 38mm is the width, as do measurements,
              // but when I printed at 38mm it came out too narrow to be gripped..


module double_arca_plate(l=40,h=10)
{
    union()
    {
        single_arca_plate(l,h/2);
        translate([width,0,h])
            rotate([0,180,0])
                single_arca_plate(l,h/2);
    }
}

module single_arca_plate(l=40,h=5)
{
    polyhedron(points=[
               [0,0,0],[0,l,0],[width,l,0],[width,0,0],
               [h,0,h],[h,l,h],[width-h,l,h],[width-h,0,h]
       ], faces=[ // points for all faces must be ordered clockwise when looking in
               [3,2,1,0],  // base face
               [4,5,6,7],  // top face
               [0,1,5,4],  // side face
               [2,3,7,6],  // side face
               [0,4,7,3],  // near end
               [2,6,5,1],  // far end
       ]);
}

//single_arca_plate();
rotate([0,180,0])
intersection()
{
    difference()
    {
        union()
        {
            single_arca_plate(50,6);
            translate([0,0,6]) cube([width,50,4]);
        }
        translate([width/2,50/2,0]) cylinder(h=10,r=5);
        translate([width/2,50/2,0]) cylinder(h=7,r=15);
    }
    roundedRect([width,50,10], 3);
}

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
        translate([radius, radius, 0])
            circle(r=radius);
        translate([x-radius, radius, 0])
            circle(r=radius);
        translate([radius, y-radius, 0])
            circle(r=radius);
        translate([x-radius, y-radius, 0])
            circle(r=radius);
    }
}

