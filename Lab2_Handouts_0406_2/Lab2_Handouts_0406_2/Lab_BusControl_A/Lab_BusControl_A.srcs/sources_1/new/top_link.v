`timescale 1ns / 1ps


module top_link(
    input [3:0]din_0, din_1, din_2, din_3,      // IO数据输入
    input BR_in_0, BR_in_1, BR_in_2, BR_in_3,   // IO请求
    output [3:0] dbus_out                       // 数据总线输出
    );

// 实例化四个IO接口，实例化控制器，并完成接线工作
wire BG,BG_out0,BG_out1,BG_out2,BG_out3;

wire BR_out_0,BR_out_1,BR_out_2,BR_out_3;
wire BS_0,BS_1,BS_2,BS_3;

wire BS = BS_0|BS_1|BS_2|BS_3;
wire BR= BR_out_0|BR_out_1|BR_out_2|BR_out_3;
controller_link u_controller_link(
	.BS (BS ),
    .BR (BR ),
    .BG (BG )
);
io_interface_link s0_io_interface_link(
	.BG_in  (BG ),
    .BG_out (BG_out0),
    .BR_in  (BR_in_0),
    .BR_out (BR_out_0),
    .BS_out (BS_0),
    .din    (din_0),
    .dout   (dbus_out)
);
io_interface_link s1_io_interface_link(
	.BG_in  (BG_out0),
    .BG_out (BG_out1),
    .BR_in  (BR_in_1),
    .BR_out (BR_out_1),
    .BS_out (BS_1),
    .din    (din_1),
    .dout   (dbus_out)
);
io_interface_link s2_io_interface_link(
	.BG_in  (BG_out1),
    .BG_out (BG_out2),
    .BR_in  (BR_in_2),
    .BR_out (BR_out_2),
    .BS_out (BS_2),
    .din    (din_2),
    .dout   (dbus_out)
);
io_interface_link s3_io_interface_link(
	.BG_in  (BG_out2),
    .BG_out (BG_out3),
    .BR_in  (BR_in_3),
    .BR_out (BR_out_3),
    .BS_out (BS_3),
    .din    (din_3),
    .dout   (dbus_out)
);


endmodule
