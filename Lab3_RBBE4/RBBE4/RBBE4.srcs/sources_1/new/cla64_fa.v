`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/03 17:28:37
// Design Name: 
// Module Name: cla64_fa
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


module cla64_fa(
        input [63:0] a_in,
        input [63:0] b_in,
        input c_in,
        output c_out,
        output g_out,
        output p_out,
        output [63:0] s_out
    );
    wire [2:0] c_middle;
    wire [3:0] g_middle;
    wire [3:0] p_middle;
    cla16_fa u0_cla16fa(.a_in(a_in[15:0]),  .b_in(b_in[15:0]),  .c_in(c_in),        .g_out(g_middle[0]), .p_out(p_middle[0]), .s_out(s_out[15:0]));
    cla16_fa u1_cla16fa(.a_in(a_in[31:16]), .b_in(b_in[31:16]), .c_in(c_middle[0]), .g_out(g_middle[1]), .p_out(p_middle[1]), .s_out(s_out[31:16]));
    cla16_fa u2_cla16fa(.a_in(a_in[47:32]), .b_in(b_in[47:32]), .c_in(c_middle[1]), .g_out(g_middle[2]), .p_out(p_middle[2]), .s_out(s_out[47:32]));
    cla16_fa u3_cla16fa(.a_in(a_in[63:48]), .b_in(b_in[63:48]), .c_in(c_middle[2]), .g_out(g_middle[3]), .p_out(p_middle[3]), .s_out(s_out[63:48]));
    cla4    u_cla4(.g_in(g_middle), .p_in(p_middle), .c_in(c_in), .c_out({c_out,c_middle}), .g_out(g_out), .p_out(p_out));
endmodule
