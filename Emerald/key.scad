// Row 4 decorated Cherry MX key

// dimensions Cherry MX connector
c_corr = .4;                // tolerance
c_horiz = 1.1;              // horizontal bar width
c_vert = 1.0;               // vertical bar width
c_dia = 4;                  // cross width
c_depth = 6;                // connector depth
c_space = 4;                // height of hollow inside
c_inset = 0.75;              // distance connector start to keycap base

// decoration
obj = "emerald.stl";          // decoration object
obj_pos = [0,0.7,2.5];        // decoration offset
factor_em = 1.1;
obj_scale = [0.8*factor_em,1.1*factor_em,1.1*factor_em]; // decoration scale
obj_rot = [3,0,0];          // decoration rotation

// keycap shape
head_tilt = 3;              // rotation of top around x-axis
head_pos = 2.25;            // keycap top y-offset
head_height = 11;           // z-offset of keycap top from the bottom of the keycap
cutoff = 6.5;               // cut keycap here to make room for decoration
                            // must be bigger than c_space + c_corr
key_scale = [1.02,1.02,1.02]; // overall scale

// stuff
$fn = 64;

module triangle()
{

}

// create basic key shape from dxf frames for base and top
module shape()
{
    hull()
    {
        translate([0,0,-c_inset]) linear_extrude(height=.01) import("base.dxf");
        rotate([head_tilt,0,0]) translate([0,6.75+head_pos,head_height-c_inset]) linear_extrude(height=.01) import("top.dxf");
    }
}

// construct the connector pin
module connector() 
{
    translate([0,0,c_depth/2-.1]) union()
    {
        cube([c_vert+c_corr,c_dia+c_corr,c_depth+.1], center=true );
        cube([c_dia+c_corr,c_horiz+c_corr,c_depth+.1], center=true );
    }
}

// create the hollow key with decoration
module key()
{
    difference()
    {
        // combine basic key shape with decoration
        union()
        {
            translate(obj_pos) rotate(obj_rot) scale(obj_scale) import(obj);         


            difference()
            {
                shape();
                rotate([head_tilt,0,0]) translate([0,0,5+cutoff-c_inset]) cube([100,100,10], center=true);
            }
        }

        // subtract scaled basic shape, cut at minimum required height
        difference()
        {
            scale([.9,.9,.9]) translate([0,0,-1]) shape();
            translate([0,0,5+c_space+c_corr]) cube([100,100,10], center=true);
        }
    }
}

// combine key, pin and connector. cleanup below the key
scale(key_scale) difference()
{
    union() 
    { 
        key();
        cylinder( h=c_space+c_corr, r=(c_dia+1+c_corr)/2 );
			
			//RTS support structure
			//connector
			rotate([0,0,45])
			{
				translate([-0.5,-6,-0.75]) cube([1,5,0.75], center=false);
				translate([-0.5,1,-0.75])  cube([1,5,0.75], center=false);
				translate([1,-0.5,-0.75])  cube([5,1,0.75], center=false);
				translate([-6,-0.5,-0.75]) cube([5,1,0.75], center=false);
			}
			translate([-0.5,-6,-0.75]) cube([1,4,0.75], center=false);
			translate([-0.5,2,-0.75])  cube([1,4,0.75], center=false);
			translate([2,-0.5,-0.75])  cube([4,1,0.75], center=false);
			translate([-6,-0.5,-0.75]) cube([4,1,0.75], center=false);		
			//roof
			translate([-4.5,-4.5,-0.75]) cube([1,1,8], center=false);		
			translate([3.5,4.25,-0.75])   cube([1,1,8], center=false);		
			translate([-4.5,4.25,-0.75])  cube([1,1,8], center=false);		
			translate([3.5,-4.5,-0.75])  cube([1,1,8], center=false);		
			
			translate([-0.5,-5,-0.75]) cube([1,1,8], center=false);		
			translate([4.5,0,-0.75])   cube([1,1,8], center=false);		
			translate([-5.5,0,-0.75])  cube([1,1,8], center=false);		
			translate([-0.5,4.75,-0.75])  cube([1,1,8], center=false);		
			
			//END RTS support structure 
	}
    
	connector();
	translate([0,0,-50-c_inset]) cube([100,100,100], center=true);
}
