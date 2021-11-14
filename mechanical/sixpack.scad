///< Object definition
/*
Six Pack Cherry MX macro pad
Author Ryan Nordeen
*/

/*
Parameters
*/

// Height
h = 2; // [0:1:10]

fname = "switch.dxf"; // [ switch.dxf, open.dxf, closed.dxf, top.dxf, bottom.dxf ]

///< Parameters after this are hidden from the customizer
module __Customizer_Limit__(){}


///< Modules
module svg( svg, height ){
    linear_extrude( height )
        import( svg );//center = false, dpi= 96);

}

///< Build object
echo("Selected: ", fname );
svg(fname, h );

