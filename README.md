# sixpack
Six-Pack Cherry MX Macro Pad

# Layout
Six Switch MX Layout

# Plate & Case

 * Switch Type: MX {_t:3}
 * Stabilizer Type: Cherry + Costar {_s:1}
 * Case Type: Sandwich
 * USB Cutout: On
   * Location: 0 (default)
   * Width: 12
 * Mount Holes: 4, 3, 8
 * Edge Padding: On, 10,10,10,10 (W,N,E,S)
 * Plate Corners: On, 4
 * Custom Polygons: Off
 * Kerf: Off
 * Key Unit Size: Off
 * Line Color: Off
 * Line Weight: Off

# QMK
## Setup
## Flashing
### Linux Issues
On Ubuntu 18.04 I needed to stop the ModemManger service to communicate with ttyACM0 serial device. 

    sudo systemctl stop ModemManager.service
    sudo systemctl disable ModemManager.service
    
 ## Customization
 TODO

# Resources
 * https://www.youtube.com/watch?v=IKe_hrvYH1M
 * http://www.keyboard-layout-editor.com/
 * http://builder.swillkb.com/
 * https://wiki.ai03.com/books/pcb-design/chapter/pcb-designer-guide
 * https://matt3o.com/hand-wiring-a-custom-keyboard/

## Promicro
 * https://golem.hu/guide/pro-micro-upgrade/

## Atmega32u4 Data sheet

 * http://ww1.microchip.com/downloads/en/devicedoc/atmel-7766-8-bit-avr-atmega16u4-32u4_datasheet.pdf
