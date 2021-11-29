///< Object definition
/*
Six Pack Cherry MX macro pad
Author Ryan Nordeen
*/

/*
Parameters
*/
$fn=90;
fname = "switch.dxf"; // [ switch.dxf, open.dxf, closed.dxf, top.dxf, bottom.dxf ]

///< Parameters after this are hidden from the customizer
module __Customizer_Limit__(){}
// Plate heights
switch_h   = 1.5; // [0:0.1:10]
closed_h   = 4.0; // [0:0.1:10]
open_h     = 7.0; // [0:0.1:10]
bottom_h   = 5.0; // [0:0.1:10]

// Plate and case sandwich
case_x       = 77.152; // mm
case_y       = 58.102; // mm
cut_l        = 675.565; // mm Cut path length
case_pad     = 4.0;
counter_sink = -2.0;
sink_d1       = 6.0;
sink_d2       = 4.5;
mounting_holes = [
                  [case_pad,        case_pad+0.5,            counter_sink ],
                  [case_pad,        case_y-case_pad+0.5, counter_sink ],
                  [case_x-case_pad, case_y-case_pad+0.5,     counter_sink ],
                  [case_x-case_pad, case_pad+0.5,            counter_sink ],
                  ];


// HiLetGo Pro Micro Clone
// https://www.amazon.com/gp/product/B01MTU9GOB/ref=ppx_yo_dt_b_asin_title_o00_s01?ie=UTF8&psc=1
// Item Dimensions
promicro_d = 34.00;
promicro_w = 18.50; // 18.04 ish
promicro_h = 4.00;
promicro_pad = 1.0;
usb_x      = 8.0;
usb_y      = 6.0;
usb_z      = 4.0;

///< Rst Btn dimensions
btn_x      = 6.5;
btn_y      = 6.5;
btn_z      = 5.0;
btn_d      = 4.0;


///< Modules
module pushbtn( tol = 0 ){
    btn_h = btn_z;
    color( "black" )cube( [btn_x+tol,btn_y+tol,btn_z+tol], true );
    translate([0,0,-btn_h])
        color( "silver" )
        cylinder( h=btn_h, d=btn_d, center = true, $fn=90 );
}

module promicro( tol = 0 ){
    color("green")
        cube( [ promicro_w+tol, promicro_d+tol, promicro_h+tol ], true );
    if( tol == 0 ){
        translate( [ 0, promicro_d/2, 0 ] )
            color("silver")
            cube( [ usb_x, usb_y, usb_z ], true );
    }
}

module counter_sinks(){
    for( p = mounting_holes ){
        translate( p )
            color("pink")
            #cylinder( h = bottom_h, d1 = sink_d1, d2 = sink_d2, true );
    }
}

module dxf( f, height ){
    echo( "DXF: ", f, "Height: ", height );
    linear_extrude( height )
        import( f );//center = false, dpi= 96);
}

///< Build object
if( ( fname == "closed.dxf" ) ){
    dxf( fname, closed_h );
 } else if( ( fname == "open.dxf") ) {
    dxf( fname, open_h );
 } else if( ( fname == "bottom.dxf" ) ) {
    translate( [ case_x/2, case_y/2, bottom_h+1, ] )
        difference(){
        promicro(promicro_pad);
        translate([0,0,1])
            promicro();
    }
    difference(){
        dxf( fname, bottom_h );
        translate( [ case_x/4, case_y/4, bottom_h-1 ] )
            #pushbtn();
        counter_sinks();
    }
 } else {
    dxf(fname, switch_h );
 }


