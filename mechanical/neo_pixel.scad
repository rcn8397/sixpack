///< Alitovo Neo pixel RGB X000UCVKBH 2812b-1-LED-WH


///< Parameters - Begin
$fn = 60;

///< Package size
led_assembly_h = 2.8;
led_assembly_d = 9.6;
package_h = 2.8;
package_d = 9.6;

///< Diameter of the PCB 
pcb_d = 9.6;
pcb_h = 1.2;

///< Demensions of the LED IC
led_w = 5;
led_d = led_w;
led_h = led_assembly_h - pcb_h;

solder_pad_w = 2.5;
solder_pad_d = 1.5;
solder_pad_h = 50; //< Large as the value isn't passed into neopixel

num_leds = 3;
padding  = 1;
left_padding = 1;
right_padding = 1;
lpad_channeled = true;
rpad_channeled = true;
tolerance      = 0.5;


include_solder_pads = true;
use_hulled_pads     = true;
use_all_pads_hulled = false;
use_as_jig          = false;

///< Modules
module pcb(h = pcb_h, d = pcb_d){
     ///< LED PCB definition
     ///< The h/d parameters are passed in to
     ///< allow for socketing of the LEDs.
    color( "white" )cylinder( h=h, d=d, center = true, $fn = 30 );
}

module led(){
     ///< Neo pixel LED (2812b-1)
     union(){
         color( "silver" )cube( [ led_w, led_d, led_h ], center = true );
         color( "lime" )
             cylinder( h=led_h, d= led_w, center = true, $fn = 30 );
         }
}

module solder_pad(){
    cube( [ solder_pad_w, solder_pad_d, solder_pad_h ], center = true );
}

module solder_pads(){
     translate([1+solder_pad_w/2,0,-solder_pad_h/2])
         solder_pad();
     translate([1+solder_pad_w/2,2,-solder_pad_h/2])
         solder_pad();
     translate([1+solder_pad_w/2,-2,-solder_pad_h/2])
         solder_pad();
}

module solder_pads_mirrored(){
     solder_pads();
     mirror([1,0,0])
         solder_pads();
}

module hulled_pads(){
    hull(){
        solder_pads();
    }
}

module hulled_pads_mirrored(){
    hulled_pads();
     mirror([1,0,0])
         hulled_pads();
}

module all_pads_hulled(){
    hull(){ hulled_pads_mirrored(); }
}

module neo_pixel(h=pcb_h, d=pcb_d ){
     ///< Assembly of the led and pcb_pad
     union(){
         translate([0,0,h-0.01])led();
          pcb(h=h, d=d);
          }
     if( include_solder_pads ){
         solder_pads_mirrored();
         if( use_hulled_pads ){
             if( use_all_pads_hulled ){
                 all_pads_hulled();
             } else {
                 hulled_pads_mirrored();
             }
         } else {
             solder_pads_mirrored();
         }
     }
}

module pixel_iter( num_pixels = 1, pad = 1, tol = 0.55, jig_h = 0 ){
    //< PCBs
    cylinder_d = pcb_d+tol;
    cylinder_h = package_h+jig_h;

    origin = pad/2 + cylinder_d/2;
    translate([origin,0,0] ){
        for( i = [ 0 : num_pixels-1 ] ){
            x = (i * (pad + cylinder_d) );
            translate([x, 0, pad ])
                cylinder( h = cylinder_h, d = cylinder_d, center = true );
            translate([x, 0, 0 ])
                neo_pixel();
        }
    }
}

///< Calculate the cubes width given N pixels with a P pad and T tolerance
function cube_w( n = 1, p = 1, t = 0.5 ) = ( ( (n+1)*p ) + (n*pcb_d) + (t*n-1));

module cube_iter( num_pixels = 1, pad = 1, tol = 0.5, channeled = true ){
    //< Cube that acts as the housing for the led
    cube_d = pcb_d+pad*2;
    cube_h = package_h+pad;
    w = cube_w(num_pixels, pad, tol );
    translate([ w/2, 0, 0] ){
        difference(){
            color("lime")cube([w, cube_d, cube_h], center=true );
            if( channeled ){
                translate( [0,0,pad] )
                    #cube( [ w , pcb_d/2, package_h ],center=true );
            }
        }
    }
}

module pixel_strip(
                   num_pixels   = 3,
                   pad          = 1,
                   lpad         = 1,
                   lpad_channel = true,
                   rpad         = 1,
                   rpad_channel = true,
                   tol          = 0.5,
                   is_jig       = false,
                   ){
    lpad_w = cube_w( lpad, pad, tol );
    mpad_w = cube_w( num_pixels+lpad, pad, tol );
    rpad_w = cube_w( num_pixels+lpad+rpad, pad, tol );

    cube_iter( lpad, pad, tol, lpad_channel );
    translate( [ lpad_w, 0, 0 ] ){
        difference(){
            cube_iter( num_pixels, pad, tol, channeled = true );
            if( is_jig ){
                #pixel_iter( num_pixels, pad = pad, tol, jig_h = package_h+2*pad );
            } else {
                #pixel_iter( num_pixels, pad = pad, tol );
            }
        }
    }
    translate( [mpad_w, 0, 0 ])
        cube_iter( rpad, pad, tol, rpad_channel );
}

///< Build object
///< Remove this when including

//neo_pixel();

pixel_strip(
            num_pixels   = num_leds,
            pad          = padding,
            lpad         = left_padding,
            lpad_channel = lpad_channeled,
            rpad         = right_padding,
            rpad_channel = rpad_channeled,
            tol          = tolerance,
            is_jig       = use_as_jig,
            );



