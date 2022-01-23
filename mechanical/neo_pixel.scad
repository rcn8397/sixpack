///< Alitovo Neo pixel RGB X000UCVKBH 2812b-1-LED-WH


///< Parameters - Begin
led_assembly_h = 2.8;
led_assembly_d = 9.6;

///< Diameter of the PCB 
pcb_d = 9.6;
pcb_h = 1.2;

///< Demensions of the LED IC
led_w = 5;
led_d = led_w;
led_h = led_assembly_h - pcb_h;

solder_pad_w = 2.5;
solder_pad_d = 1.5;
solder_pad_h = 2;

include_solder_pads = true;

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

module neo_pixel(h=pcb_h, d=pcb_d ){
     ///< Assembly of the led and pcb_pad
     union(){
         translate([0,0,h-0.01])led();
          pcb(h=h, d=d);
          }
     if( include_solder_pads ){
         solder_pads_mirrored();
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

module pixel_iter( num_pixels = 1, lpad = 2, rpad = 0, z_offset = 0.9 ){
    //< PCBs
    for( i = [ 0 : num_pixels-1 ] ){
        x = lpad+(i * pcb_d)+(i * rpad)+(i * lpad);
        translate([x, 0, 0 ])
            neo_pixel();



        
//        translate([x-pcb_d/4, -pcb_d/4, (-pcb_h/2)-z_offset])
//        mirror([1,0,0])
//                #cube([1/2.5*pcb_d, pcb_d/2, pcb_h] );
//        translate([x+pcb_d/4, -pcb_d/4, (-pcb_h/2)-z_offset])
//                #cube([1/2.5*pcb_d, pcb_d/2, pcb_h] );

//        y = x-pcb_d/2;
//        translate([y, -pcb_d/4, (-pcb_h/2)-z_offset])
//            #cube([1/2.5*pcb_d, pcb_d/2, pcb_h] );
//        n = x+pcb_d/8;
//        translate([n, -pcb_d/4, (-pcb_h/2)-z_offset])
//            #cube([1/2.5*pcb_d, pcb_d/2, pcb_h] );


    }
}

module cube_iter( num_cubes = 1, lpad = 2, rpad = 0, z_offset = 0.1, dir = 1) {
    //< Sled 
    for( i = [ 0 : num_cubes-1 ] ){
        x = lpad+(i * pcb_d)+(i * rpad)+(i * lpad);
        cube_w = pcb_d;
        cube_d = pcb_d;
        cube_h = pcb_h;
        translate([ -cube_w/2, -cube_d/2, ((-pcb_h/2)-z_offset)*dir ] )
            color("lime")cube([x+pcb_d, pcb_d, pcb_h], false );
    }
}

module pixel_sled_bottom(num_pixels = 1, lpad = 2, rpad = 1, z_offset = 0.1){
        cube_iter( num_pixels,  lpad, rpad, z_offset, dir = 1 );
}

module pixel_sled_top( num_pixels = 1, lpad = 2, rpad = 1, z_offset = 0.1 ){
        cube_iter( num_pixels,  lpad, rpad, z_offset, dir = -1 );
}

module pixel_strip(){
    difference(){
        union(){
            pixel_sled_bottom(2, lpad = 2, rpad = 2);
            //translate([0.5,0,0] ) pixel_sled_top(2, lpad = 2, rpad=1);
        }
        pixel_iter( 2 );
    }
}

///< Build object
///< Remove this when including
//neoclip();

neo_pixel();

