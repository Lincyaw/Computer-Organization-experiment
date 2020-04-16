`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/03 17:07:09
// Design Name: 
// Module Name: cla16_fa
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cla16_fa(
        input [15:0] a_in,
        input [15:0] b_in,
        input c_in,
        output c_out,
        output g_out,
        output p_out,
        output [15:0] s_out
    );
    wire [2:0] c_middle;
    wire [3:0] g_middle;
    wire [3:0] p_middle;
    cla4_fa u0_cla4fa(.a_in(a_in[3:0]),   .b_in(b_in[3:0]),   .c_in(c_in),        .g_out(g_middle[0]), .p_out(p_middle[0]), .s_out(s_out[3:0]));
    cla4_fa u1_cla4fa(.a_in(a_in[7:4]),   .b_in(b_in[7:4]),   .c_in(c_middle[0]), .g_out(g_middle[1]), .p_out(p_middle[1]), .s_out(s_out[7:4]));
    cla4_fa u2_cla4fa(.a_in(a_in[11:8]),  .b_in(b_in[11:8]),  .c_in(c_middle[1]), .g_out(g_middle[2]), .p_out(p_middle[2]), .s_out(s_out[11:8]));
    cla4_fa u3_cla4fa(.a_in(a_in[15:12]), .b_in(b_in[15:12]), .c_in(c_middle[2]), .g_out(g_middle[3]), .p_out(p_middle[3]), .s_out(s_out[15:12]));
    cla4    u_cla4(.g_in(g_middle), .p_in(p_middle), .c_in(c_in), .c_out({c_out,c_middle}), .g_out(g_out), .p_out(p_out));
endmodule
