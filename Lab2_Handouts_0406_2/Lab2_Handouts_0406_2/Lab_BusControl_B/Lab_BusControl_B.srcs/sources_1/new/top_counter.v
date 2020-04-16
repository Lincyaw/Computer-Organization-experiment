`timescale 1ns / 1ps


module top_counter(
    input clk,rst,
    input [3:0]din_0, din_1, din_2,din_3,
    input BR_in_0, BR_in_1, BR_in_2, BR_in_3,
    input mode,
    input [1:0]cnt_rstval,
    output [3:0] dbus_out
    );

    wire [1:0]cnt;
    wire [1:0]device_id0 = 2'b00;
    wire [1:0]device_id1 = 2'b01;
    wire [1:0]device_id2 = 2'b10;
    wire [1:0]device_id3 = 2'b11;
    wire BR_out_0,BR_out_1,BR_out_2,BR_out_3;
    wire BS_out_0,BS_out_1,BS_out_2,BS_out_3;
    assign BR = BR_in_0|BR_in_1|BR_in_2|BR_in_3;
    assign BS = BS_out_0|BS_out_1|BS_out_2|BS_out_3;

controller_counter c0_controller_counter(
	.clk        (clk        ),
    .rst        (rst        ),
    .BR         (BR         ),
    .BS         (BS         ),
    .mode       (mode       ),
    .cnt_rstval (cnt_rstval ),
    .cnt        (cnt        )
);
io_interface_counter s0_io_interface_counter(
	.clk       (clk       ),
    .rst       (rst       ),
    .BR_in     (BR_in_0     ),
    .BR_out    (BR_out_0    ),
    .BS_out    (BS_out_0    ),
    .din       (din_0       ),
    .dout      (dbus_out      ),
    .device_id (device_id0 ),
    .cnt_in    (cnt)
);
io_interface_counter s1_io_interface_counter(
	.clk       (clk       ),
    .rst       (rst       ),
    .BR_in     (BR_in_1     ),
    .BR_out    (BR_out_1    ),
    .BS_out    (BS_out_1    ),
    .din       (din_1       ),
    .dout      (dbus_out      ),
    .device_id (device_id1 ),
    .cnt_in    (cnt)
);
io_interface_counter s2_io_interface_counter(
	.clk       (clk       ),
    .rst       (rst       ),
    .BR_in     (BR_in_2     ),
    .BR_out    (BR_out_2    ),
    .BS_out    (BS_out_2    ),
    .din       (din_2       ),
    .dout      (dbus_out      ),
    .device_id (device_id2 ),
    .cnt_in    (cnt )
);
io_interface_counter s3_io_interface_counter(
	.clk       (clk       ),
    .rst       (rst       ),
    .BR_in     (BR_in_3     ),
    .BR_out    (BR_out_3    ),
    .BS_out    (BS_out_3    ),
    .din       (din_3       ),
    .dout      (dbus_out      ),
    .device_id (device_id3 ),
    .cnt_in    (cnt   )
);
endmodule
