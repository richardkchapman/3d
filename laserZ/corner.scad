channelHeight = 25.7;
channelWall = 1.6;
channelBottom = 25.4;
channelTop = 12.7;

plugDepth = 5;
armLength = 30;
armThickness = 5;
cutoutDiameter = 11.5;
cutoutX = 5+cutoutDiameter/2;
cutoutY = 13;
rivet = 4;

delta = 1;

mirror([0,1,0])
difference()
{
    union()
    {
        cube([channelBottom, channelBottom, channelHeight-channelWall]);
        translate([channelWall,0,0])
          cube([channelBottom-channelWall, channelBottom+plugDepth, channelHeight-channelWall*2]);
        translate([0,channelWall,0])
        {
          cube([channelBottom+plugDepth, channelTop-channelWall, channelHeight-channelWall*2]);
          translate([0,channelTop-channelWall,0])
          rotate([0,-90,-90])
            prism(channelBottom+plugDepth, channelHeight-channelWall*2, channelTop-channelWall);
        }
        translate([channelWall,0,0])
          cube([armThickness, channelBottom+plugDepth+armLength, channelHeight-channelWall*2]);
        translate([0,channelWall,0])
          cube([channelBottom+plugDepth+armLength, armThickness, channelHeight-channelWall*2]);
    }
    translate([0,0,-delta/2])
      hull()
      {
        translate([cutoutX, cutoutY, 0])
          cylinder(h=channelHeight+delta, d=cutoutDiameter);
        translate([cutoutX, -cutoutY, 0])
          cylinder(h=channelHeight+delta, d=cutoutDiameter);
      }
    translate([0,channelBottom+plugDepth+armLength/4,(channelHeight-channelWall*2)/2])
      rotate([0,90,0]) cylinder(h=channelWall+armThickness+delta, d=rivet, $fn=20);
    translate([0,channelBottom+plugDepth+3*armLength/4,(channelHeight-channelWall*2)/2])
      rotate([0,90,0]) cylinder(h=channelWall+armThickness+delta, d=rivet, $fn=20);

    translate([channelBottom+plugDepth+armLength/4,0,(channelHeight-channelWall*2)/2])
      rotate([-90,0,0]) cylinder(h=channelWall+armThickness+delta, d=rivet, $fn=20);
    translate([channelBottom+plugDepth+3*armLength/4,0,(channelHeight-channelWall*2)/2])
      rotate([-90,0,0]) cylinder(h=channelWall+armThickness+delta, d=rivet, $fn=20);
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
