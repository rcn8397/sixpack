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
solder_pad_h = 10;

num_leds = 3;

include_solder_pads = true;
use_hulled_pads     = true;
use_all_pads_hulled = false;

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

module pixel_clip_v1(lead_d = 1, foot_t = 2){
    width = pcb_d/2+pcb_d/2+led_w;
    zmag  = (led_h+lead_d/2);
    module retainer_qrt(){
        translate([pcb_d/2,0,0])
            cube( [ pcb_d/2, pcb_d,led_h ], center=true );
        translate([-pcb_d/2,0,0])
            cube( [pcb_d/2, pcb_d, led_h ], center=true );
    }
    translate([0,0,pcb_h])
        retainer_qrt();
    translate([0,0,-zmag ])
        retainer_qrt();

    translate([-width/2,-pcb_d/2-foot_t/2,-zmag-led_h/2 ])
        color("red")cube([width, foot_t, led_h+lead_d/2+led_h+pcb_h]);
}

module neoclip( lead_d = 1, rot = 0, foot_h = 1, tol = 0.25 ){
    post_dim = [led_h-0.1, pcb_d/2, pcb_d];
    
    module retainer_post(){
        translate([pcb_h,pcb_d/2+tol,0])
            cube( post_dim, center=true);   
    }
    module z_axis_pixel(){
    rotate_about_pt( rot , 90, [0,0,0])
        neo_pixel();
    }
    module front_post(){
        retainer_post();
        mirror([0,1,0])
            retainer_post();
    }
    module back_post(){
        //cube([ led_h-0.1, pcb_d+led_w+tol, pcb_d ],center=true);
        cube([ led_h-0.1, pcb_d, pcb_d ],center=true);
    }

    module foot(){
        x=pcb_h*2+lead_d+led_h-0.1;
        y=pcb_d+led_w+tol;
        color("pink")
            translate([-lead_d/2,0,-foot_h/2])
            cube([ x, y, foot_h ],center=true);
    }

    module three_posts(include_foot=true){
            front_post();
            translate([-pcb_h-lead_d,0,0])
                back_post();
            if( include_foot ){
                translate([0,0,-pcb_d/2])
                    foot();
            }
    }
    
    difference(){
        rotate([0,0,rot]){
            three_posts();
        }
        #z_axis_pixel();
    }
}


module padding( p = 1 ){
    w = p;
    d = pcb_d+p*2;
    h = package_h;
    color("cyan")cube([w,d,h], center = true );
}

module pixel_iter( num_pixels = 1, pad = 1, tol = 0.55  ){
    //< PCBs
    cylinder_d = pcb_d+tol;
    cylinder_h = package_h;

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
                   tol          = 0.5
                   ){
    lpad_w = cube_w( lpad, pad, tol );
    mpad_w = cube_w( num_pixels+lpad, pad, tol );
    rpad_w = cube_w( num_pixels+lpad+rpad, pad, tol );

    cube_iter( lpad, pad, tol, lpad_channel );
    translate( [ lpad_w, 0, 0 ] ){
        difference(){
            cube_iter( num_pixels, pad, tol, channeled = true );
            pixel_iter( num_pixels, pad = pad, tol );
        }
    }
    translate( [mpad_w, 0, 0 ])
        cube_iter( rpad, pad, tol, rpad_channel );
}

module pixel_channel_1u( t = 1 ){
    difference(){
        ///< Outer cube
        translate([0,pcb_d/2, 0])
            cube([ (2*t)+pcb_d, pcb_d, package_h + (2*t) ], center = true );
        ///< LED cut
        translate([0,0,package_h-(2*t)])
            cube([led_w, 1000, led_h+(2*t)], center = true );
        ///< PCB cut
        cube([ pcb_d+1, 1000, pcb_h+1], center = true );
        ///< Solder/wire cut
        translate([0,0,-solder_pad_h/2])
            cube([ solder_pad_w*2+2, 1000, solder_pad_h], center = true );
        ///< Debug cut
        translate([0,pcb_d/2, 0 ] )
            #neo_pixel();
    }
}

module channel_iter( num_pixels = 1, t = 1 ){
    for( i = [ 0 : num_pixels-1 ] ){
        y = ( i * pcb_d );
        translate([ 0, y, 0 ] )
            pixel_channel_1u( t = t );
    }
}
///< Build object
///< Remove this when including
//neoclip();

//neo_pixel();

pixel_strip(num_leds);

//channel_iter( 2 );




