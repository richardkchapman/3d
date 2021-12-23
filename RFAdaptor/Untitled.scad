
difference()
{
  union()
  {
   intersection()
    {
     import("RFAdaptorPlainBayonette.stl");
     translate([0,0,-10]) cylinder(h=50,d=61, $fn=60);
    }
   rotate([180,0,0]) 
    cylinder(h=10.1, d=61, $fn=60);
  }
  rotate([180,0,0]) 
  {
   translate([0,0,1.55])
    cylinder(h=10.1, d=56, $fn=100);
   translate([0,0,-20])
    cylinder(h=40, d=47, $fn=100);
  }
  rotate([180,0,0])
    translate([0,0,9])
      cylinder(h=2, r1=28, r2=28.5, $fn=100); 
}



