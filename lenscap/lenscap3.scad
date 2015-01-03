//lens cap
threadHeight = 3;    // height of "threaded" part (smaller cylinder)
topHeight = 4;       // height of "cap" part
springHeight = 2;    // height of springs
gap = 1;             // clearance 
wall = 1.5;          // wall thickness
springY=15;          //size of spring in y direction.
springThickness = 2;
travel = 2;          //distance the clip will stick out past the lens
diameter = 76;       // For a 77mm lens this seems to work
capDiameter = 80;
holeDiameter = 6;    // size of holes for studs
numStuds = 3;        // 3 or 2 are supported
part = 0;            // set to 1, 2, or 3 to generate stl for whichever part you wanted

lensRadius = diameter/2; 
overhang = (capDiameter - diameter)/2;
channelWidth=lensRadius;
springBase = threadHeight+topHeight-(springHeight+wall+gap);
springLength=springY-2*springThickness;
springWidth=(lensRadius-springLength)/2-springThickness-gap;

// Total height is topHeight + threadHeight
// Clearance for glass is topHeight - (gap + springHeight)

$fs = 0.5;
$fn = 0;
$fa = 0.01;

module spring()
{
  block=springThickness*4;
  translate([0,0,springBase])
  {
    translate([0, springThickness])
      difference()
      {
        union()
        {
          cube([springWidth,springLength,springHeight]);
          translate([springWidth,springLength/2]) 
            cylinder(r=springLength/2, h=springHeight);
        }
        translate([-springWidth,springThickness]) 
          cube([springWidth*2,springLength-springThickness*2,springHeight]);
        translate([springWidth,springLength/2]) 
          cylinder(r=(springLength-springThickness*2)/2, h=springHeight);
      }
    translate([-block/2,-block/2]) cube([block,block,springHeight]);
    translate([-block/2,springY-block/2]) cube([block,block,springHeight]);
  }
}

//channel for sliding through;
module slideChannel(w=channelWidth)
{
  side = w/1.44;
  stretch = 1.5;// value of 1 will leave the channel at 45 degrees, higher numbers reduce the slope
  translate([0,0,(threadHeight+topHeight-springBase)/2+springBase])
    scale([1,1,stretch])
      rotate([0,45,0])
        cube([side,4*lensRadius,side],true);
}

module clips()
{
  module oneClip()
  {
    translate([0,travel,0])
      difference()
      {
        intersection()
        {
          capShape();
          slideChannel();
        }
        translate([-lensRadius,-2*lensRadius+springY-travel,-lensRadius])
          cube([2*lensRadius,2*lensRadius,2*lensRadius]);
        translate([0,0,springBase + springHeight + (wall+gap)/2]) 
          cube([channelWidth,lensRadius+2*travel,wall+gap],true);
        cylinder(h=springBase, r=lensRadius-wall);
//        translate([-(lensRadius+overhang),-(lensRadius+overhang), 0]) 
  //        cube([(lensRadius+overhang)*2, (lensRadius+overhang)*2, springBase]);
      }
  }

  oneClip();
  mirror([0,1,0]) oneClip();
}

module frame()
{
  topThickness = wall;
  union()
  {
    difference()
    {
      capShape();
      slideChannel(channelWidth+gap);
      translate([0,0,(threadHeight+topHeight-topThickness)/2]) cube([channelWidth+wall*5,2,threadHeight+topHeight-topThickness],true);
      difference()
      {
        cylinder(r=lensRadius-wall, h=threadHeight+topHeight-topThickness);
        translate([0,0,(threadHeight+topHeight)/2]) cube([channelWidth+wall*4,lensRadius*2,threadHeight+topHeight],true);
      }
      cylinder(r=lensRadius-wall, h=springBase);
      translate([-(channelWidth)/2, -lensRadius-overhang, 0])
        cube([channelWidth, (lensRadius+overhang)*2, springBase]);
    }
    // Centre 
    translate([0,0,threadHeight+topHeight-topThickness/2]) cube([channelWidth,lensRadius,topThickness],true);
    // Centre crossbrace
    translate([0,0,springBase + springHeight + gap/2]) cube([channelWidth+wall*2,2,gap],true);
  }
}

module capShape(){
	union(){
		cylinder(r=lensRadius, h=threadHeight+topHeight);
		translate([0,0,threadHeight])
			cylinder(r=lensRadius+overhang, r2=lensRadius+overhang-0.5, h=topHeight);
	}
}

module lensCapBase()
{
  color([1,0,0])
  {
    spring();
    rotate([0,0,180]) spring();
    mirror([0,1,0]) spring();
    rotate([0,0,180]) mirror([0,1,0]) spring();
  }

  color([0,0,1]) clips();
  translate([0,0,springBase + springHeight/2]) cube([channelWidth+wall*2,2,springHeight],true);
}

module lensCapBase1()
{
  holex = lensRadius+travel-holeDiameter;
  difference()
  {
    lensCapBase();
    translate([-lensRadius-overhang-travel-2, -lensRadius-overhang-travel-2, threadHeight+topHeight-wall-gap])
      cube([(lensRadius+overhang+travel+2)*2, (lensRadius+overhang+travel+2)*2, wall+gap]);
    translate([-channelWidth/4, -holex, springBase]) hole();
    translate([channelWidth/4, -holex, springBase]) hole();
    translate([-channelWidth/4, holex, springBase]) hole();
    translate([channelWidth/4, holex, springBase]) hole();
    if (numStuds==3)
    {
      translate([0,-lensRadius/2-travel-holeDiameter, springBase]) hole();
      translate([0,lensRadius/2+travel+holeDiameter, springBase]) hole();
    }
  }
}

module stud()
{
  difference()
  {
    union()
    {
      translate([0,0,springHeight*1/3]) cylinder(r=holeDiameter/2 - 0.25,h=springHeight*2/3);
      cylinder(r2=holeDiameter/2 + 0.25,r=holeDiameter/2 - 0.25,h=springHeight*1/3);
    }
    translate([0,0,springHeight/2]) cube([1.5,8,springHeight],true);
  }
}

module hole()
{
    union()
    {
      translate([0,0,springHeight/2]) cylinder(r=holeDiameter/2,h=springHeight/2);
      cylinder(r=holeDiameter/2 +1,h=springHeight/2);
    }
}

module lensCapBase2()
{
  holex = lensRadius+travel-holeDiameter;
  difference()
  {
     lensCapBase();
     translate([-lensRadius-overhang-travel-2, -lensRadius-overhang-travel-2, 0])
       cube([(lensRadius+overhang+travel+2)*2, (lensRadius+overhang+travel+2)*2, threadHeight+topHeight-wall-gap]);
  }

  translate([-channelWidth/4, -holex, springBase]) stud();
  translate([channelWidth/4, -holex, springBase]) stud();
  translate([-channelWidth/4, holex, springBase]) stud();
  translate([channelWidth/4, holex, springBase]) stud();
  if (numStuds==3)
  {
    translate([0,-lensRadius/2-travel-holeDiameter, springBase]) stud();
    translate([0,lensRadius/2+travel+holeDiameter, springBase]) stud();
  }
}

module lensCapTop()
{
  color([0,1,0]) frame();
}

module crossSection(){
	difference(){
		lensCap();
		translate([0,0,-lensRadius])cube(2*lensRadius);
	}
}

mirror([0,0,1]) {
  if (part==0 || part==1)
    lensCapTop();
  if (part==0 || part==2)
    lensCapBase1();
  if (part==0 || part==3)
    lensCapBase2();
}