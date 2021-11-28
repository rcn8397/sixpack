///< Object definition
/*
Six Pack Cherry MX macro pad
Author Ryan Nordeen
*/

/*
Parameters
*/

// Height
h = 1.5;           // [0:0.1:10]
internal_h = 5.0; // [0:0.1:10]
fname = "switch.dxf"; // [ switch.dxf, open.dxf, closed.dxf, top.dxf, bottom.dxf ]

///< Parameters after this are hidden from the customizer
module __Customizer_Limit__(){}

// Plate and case sandwich
case_x = 77.152; // mm
case_y = 58.102; // mm
cut_l  = 675.565; // mm Cut path length

// HiLetGo Pro Micro Clone
// https://www.amazon.com/gp/product/B01MTU9GOB/ref=ppx_yo_dt_b_asin_title_o00_s01?ie=UTF8&psc=1
// Item Dimensions
promicro_d = 33.50;
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
    btn_h = btn_z/2;
    color( "black" )cube( [btn_x,btn_y,btn_z], true );
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

module svg( svg, height ){
    linear_extrude( height )
        import( svg );//center = false, dpi= 96);
}

///< Build object
echo("Selected: ", fname );
if( ( fname == "open.dxf") || ( fname == "closed.dxf" ) ){
    svg( fname, internal_h );
 } else if( ( fname == "bottom.dxf" ) ) {
    translate( [ case_x/2, case_y/2, h+1, ] )
        difference(){
        promicro(promicro_pad);
        translate([0,0,1])
            promicro();
    }
    difference(){
        svg( fname, h );
        translate( [ case_x/4, case_y/4, 3 ] )
            #pushbtn();
    }

 } else {
    svg(fname, h );
 }



