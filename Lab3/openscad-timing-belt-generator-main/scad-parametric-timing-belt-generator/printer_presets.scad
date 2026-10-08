// Source: installed Bambu Studio 02.04.00.70, Resources/profiles/BBL/machine,
// including inherited printable_area and extruder_printable_area values.
// Model-size presets, not slicer exclusion/placement certification.
// [name, nominal XY, chosen reference rectangle, inset per side].
// H2 dual-tool presets use the 300x320 shared nozzle rectangle, not the union.
function printer_presets() = [
    ["Bambu_A1_mini",[180,180],[180,180],5],
    ["Bambu_A1",[256,256],[256,256],5],
    ["Bambu_P1P",[256,256],[256,256],5],
    ["Bambu_P1S",[256,256],[256,256],5],
    ["Bambu_P2S",[256,256],[256,256],5],
    ["Bambu_X1",[256,256],[256,256],5],
    ["Bambu_X1C",[256,256],[256,256],5],
    ["Bambu_X1E",[256,256],[256,256],5],
    ["Bambu_H2S",[340,320],[340,320],5],
    ["Bambu_H2D",[350,320],[300,320],5],
    ["Bambu_H2D_Pro",[350,320],[300,320],5],
    ["Bambu_H2C",[330,320],[300,320],5]
];
function printer_preset(name) = let(found=[for(p=printer_presets())if(p[0]==name)p])
    assert(len(found)==1,str("Unknown printer preset: ",name,". Use max_size for a custom printer.")) found[0];
function printer_size(name) = let(p=printer_preset(name)) p[2]-[2*p[3],2*p[3]];
// Validate explicitly supplied names even when max_size overrides their area.
function resolved_printer_size(max_size,printer,max_diameter) =
    assert(is_undef(printer) || len(printer_preset(printer))==4)
    !is_undef(max_size)?max_size:!is_undef(printer)?printer_size(printer):[max_diameter,max_diameter];
