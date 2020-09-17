include <nutsnbolts/cyl_head_bolt.scad>;
$fn = 20;
difference()
{
    import("vacusuck.stl");
    translate([-10,-47,13])
      rotate([0,90,0]) 
        union()
        {
          translate([0,0,30])
            hole_through("M4", l=30);
          nutcatch_parallel("M4", l=10, clk=0.1, clh=0.1, clsl=0.1);
        }
}