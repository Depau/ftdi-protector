pin_thickn = 1.25;
pin_h = 6.3; // 5
pin_dist_center = 2.5;
pin_header_size = pin_dist_center;
pin_header_inset_x = 1.2;
pin_header_corner_rad = .5;
row_pin_count = 13;
thickn=1;
fn=50;

board_dimens=[42.5, 37.5, 1.6];
board_corner_rad=2;
usb_dimens=[12.5, 15, 4.5];
chip_hole_dimens = [17, 23, 1.3];
chip_hole_corner_rad = 1;

total_x = board_dimens.x + thickn*2;
total_y = board_dimens.y + usb_dimens.y;
total_z = thickn + pin_h + pin_header_size + usb_dimens.z;

notch_sphere_rad=7;
notch_sphere_pos = [
    total_x/2,
    -5,
    2
];

pin_header_len = pin_header_size*row_pin_count;

difference() {
    roundedVerticesCube([
        total_x,
        total_y,
        total_z
    ], board_corner_rad, $fn=fn);


    // Board
    translate([thickn, 0])
    roundedCube([
        board_dimens.x,
        board_dimens.y,
        usb_dimens.z
    ], board_corner_rad, $fn=fn);

    // USB
    translate([total_x/2 - usb_dimens.x/2, board_dimens.y-1])
    cube(usb_dimens + [0, 1, 0]);

    // Pin header holes
    translate([
        thickn + pin_header_inset_x,
        board_dimens.y/2 - pin_header_len/2,
        usb_dimens.z-.1
    ])
    roundedCube([
        2*pin_header_size,
        pin_header_len,
        pin_header_size+.1
    ], pin_header_corner_rad, $fn=fn);

    translate([
        thickn + board_dimens.x - pin_header_inset_x - 2*pin_header_size,
        board_dimens.y/2 - pin_header_len/2,
        usb_dimens.z-.1
    ])
    roundedCube([
        2*pin_header_size,
        pin_header_len,
        pin_header_size+.1
    ], pin_header_corner_rad, $fn=fn);

    // Chip hole
    translate([
        total_x/2 - chip_hole_dimens.x/2,
        board_dimens.y/2 - chip_hole_dimens.y/2,
        usb_dimens.z-.1
    ])
    roundedCube(chip_hole_dimens+[0,0,.1], chip_hole_corner_rad, $fn=fn);

    // Pins
    translate([
        thickn + pin_header_inset_x,
        board_dimens.y/2 - pin_header_len/2 + pin_header_size/2 - pin_thickn/2,
        usb_dimens.z + pin_header_size - .1
    ])
    for (x_pos = [
        0,
        pin_dist_center,
        board_dimens.x - pin_dist_center - 2*(pin_header_size),
        board_dimens.x - 2*(pin_header_size)
    ] + [1, 1, 1, 1]*(pin_header_size/2 - pin_thickn/2)) {

        for (y_pos = [0 : pin_header_size : (row_pin_count-1)*pin_header_size]) {
            translate([x_pos, y_pos])
            cube([pin_thickn, pin_thickn, pin_h+.1]);
        }

    }

    // Notch
    translate(notch_sphere_pos)
    sphere(r=notch_sphere_rad, $fn=fn);
}

module roundedVerticesCube(dimens, corner_radius, $fn=50) {
    hull()
    for (pos = [
            [corner_radius, corner_radius, corner_radius],
            [dimens.x-corner_radius, corner_radius, corner_radius],
            [corner_radius, dimens.y-corner_radius, corner_radius],
            [corner_radius, corner_radius, dimens.z-corner_radius],
            [dimens.x-corner_radius, dimens.y-corner_radius, corner_radius],
            [corner_radius, dimens.y-corner_radius, dimens.z-corner_radius],
            [dimens.x-corner_radius, corner_radius, dimens.z-corner_radius],
            [dimens.x-corner_radius, dimens.y-corner_radius, dimens.z-corner_radius]
            
    ]) {
        translate(pos)
        sphere(r=corner_radius, $fn=fn);
    }
}


module roundedCube(dimens, corner_radius, $fn=50) {
    hull() {
        translate([corner_radius, corner_radius])
        cylinder(r=corner_radius, h=dimens.z);

        translate([corner_radius, dimens.y-corner_radius])
        cylinder(r=corner_radius, h=dimens.z);

        translate([dimens.x-corner_radius, corner_radius])
        cylinder(r=corner_radius, h=dimens.z);

        translate([dimens.x-corner_radius, dimens.y-corner_radius])
        cylinder(r=corner_radius, h=dimens.z);
    }
}