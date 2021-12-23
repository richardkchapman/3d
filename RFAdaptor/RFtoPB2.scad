use <RF_lens.scad>
use <Praktica bayonet.scad>

pod = 60;    // OD of Praktica end of adaptor
pid = 48;    // ID of Praktica end (not adjustable)
rod = 64.7;  // OD of RF end
rid = 42.7;    // ID of RF end

pb_flange = 44.4;  // PB flange distance
rf_flange = 20;    // RF flange distance

// Calculated

l = pb_flange-rf_flange;

RF_lens(height=10, od=rod, id=rid);

translate([0,0,-l])
  praktica_bayonet(h = 6, od=pod);

translate([0,0,-l+6])
difference()
{
  cylinder(h=l - 16, d1=pod, d2=rod, $fn=100);
  cylinder(h=l - 16, d1=pid, d2=rid, $fn=100);
}