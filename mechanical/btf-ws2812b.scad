use <sixpack.scad>

/*
Module: WS2812B LED strip
BTF Lighting WS2812b 5050smd LED 3.3ft 144 (2x72) pixel strips
https://www.amazon.com/gp/product/B01CDTEJR0/

https://cdn-shop.adafruit.com/datasheets/WS2812.pdf
*/

/*
Parameters
*/

// Finish/Quality
$fn = 90; // [0:90:120]

// Number of LEDs in the strip
num_leds  = 6; // [0:1:72]

// Pitch of the LEDs
led_pitch = 1.92; // [0:0.01:25]

// Channel thickness
channel_t = 1.0; // [0:1:5]
// Channel X
channel_x = 22; // [0:0.1:50]


///< Parameters after this are hidden from the customizer
module __Customizer_Limit__(){}

// WS2812B
ws2812b_w = 5.0;
ws2812b_d = 5.0;
ws2812b_h = 1.57;

// Strip Width
strip_d = 12;   // [0:0.01:15]
strip_h = 2.13 - ws2812b_h; // [0:0.01:5]


///< Modules
module ws2812b(center = true){
    color("white")cube( [ws2812b_w, ws2812b_d, ws2812b_h], center = center );
    color("yellow")cylinder( h = ws2812b_h, d = ws2812b_w*0.90, center = center );
}


function ribbon_w( n = 1, p = 1 ) = ( (n+1)*p ) + (n*ws2812b_w) ;

module strip( n = num_leds, pitch = 1, center = true ){
    
    for( i = [0:n-1] ){
        x = i * ( pitch + ws2812b_w );
        translate([x,0,0])
            ws2812b(center);
    }
    strip_w = ribbon_w(n, pitch);
    adjust  = strip_w/2 - ws2812b_w;
    translate([ adjust, 0, -ws2812b_h/2 ] )
        color("black")cube( [ strip_w, strip_d, strip_h ], center = center );
}

module channel( n = num_leds, pitch = 1, thickness = channel_t, center = true ){
    d = strip_d + thickness;
    for( i = [0:n-1] ){
        x = i * ( pitch + ws2812b_w );
        translate( [x,d/2,-thickness/2] )
            cylinder( h = ws2812b_h+thickness, d = ws2812b_w/2, center );
        translate( [x,-d/2,-thickness/2] )
            cylinder( h = ws2812b_h+thickness, d = ws2812b_w/2, center );

    }
    channel_w = ribbon_w( n, pitch );
    adjust = channel_w/2 - ws2812b_w;
    translate( [ adjust, 0, 0 ] )
        color("cyan")cube( [ channel_w, d, thickness ], center );
    
}
///< Build object

dxf( "closed.dxf", height = 2.13+channel_t );

difference(){
translate([channel_x, 44.47, channel_t/2 ] )channel( num_leds, led_pitch );
#translate([channel_x, 44.47, 2.13/2+channel_t ] )strip(num_leds, led_pitch);
}

difference(){
translate([channel_x, 14.35, channel_t/2 ] )channel( num_leds, led_pitch );
#translate([channel_x, 14.35, 2.13/2+channel_t ] )strip(num_leds, led_pitch);
}
