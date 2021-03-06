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

## 3D Printing
The plate and case are also hosted on [prusaprinters.org](https://www.prusaprinters.org/prints/113097-sixpack)

### Openscad
Each layer can be generated/customized using openscads customizer. 

### Slicing
I use Cura to slice, but I suspect any slicer will work. 

* Nozzle: 0.4mm
* Layer Height: 0.2mm
* Supports: No

# QMK
## Setup
## Compiling
Compile the code using QMK

     qmk compile -kb handwired/sixpack  -km default
     
## Flashing
Flash the target (ProMicro), note you must hit the reset switch to enter bootloader.

     qmk flash -kb handwired/sixpack  -km default
     
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

## QMK
 * https://docs.qmk.fm/#/
 * https://docs.qmk.fm/#/hand_wire
 * Sixpack firmware (QMK forked) https://github.com/rcn8397/qmk_firmware/tree/personal/nordeen%2Fsixpack
 * Work flow https://docs.qmk.fm/#/newbs_git_using_your_master_branch

### QMK Git Workflow/Setup
Add the forked repo as a remote

      git remote add myfork git@github.com:rcn8397/qmk_firmware.git
      
Next verify the forked repo was added

      git remote -v
      
Should look something like:

      myfork	git@github.com:rcn8397/qmk_firmware.git (fetch)
      myfork	git@github.com:rcn8397/qmk_firmware.git (push)
      origin	https://github.com/qmk/qmk_firmware.git (fetch)
      origin	https://github.com/qmk/qmk_firmware.git (push)
      
Next push the development branch to the fork and track it.

      git push -u myfork

## Promicro
 * https://deskthority.net/wiki/Arduino_Pro_Micro#Pinout
 * https://golem.hu/guide/pro-micro-upgrade/
 * https://learn.sparkfun.com/tutorials/pro-micro--fio-v3-hookup-guide/troubleshooting-and-faq#ts-reset

## Atmega32u4 Data sheet

 * http://ww1.microchip.com/downloads/en/devicedoc/atmel-7766-8-bit-avr-atmega16u4-32u4_datasheet.pdf
