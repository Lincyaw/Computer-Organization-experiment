`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/03 21:36:48
// Design Name: 
// Module Name: rba64
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


module rba64(
    input [63:0] x_pos_in,
    input [63:0] x_neg_in,
    input [63:0] y_pos_in,
    input [63:0] y_neg_in,
    input c_pos_in,
    input c_neg_in,
    input neg_in,
    output c_pos_out,
    output c_neg_out,
    output [63:0] z_pos_out,
    output [63:0] z_neg_out,
    output neg_out
    );
    
    wire [64:0] _c_pos;
    wire [64:0] _c_neg;
    wire [64:0] _neg;
    assign _c_pos[0] = c_pos_in;
    assign _c_neg[0] = c_neg_in;
    assign _neg[0]   = neg_in;
    assign c_pos_out = _c_pos[64];
    assign c_neg_out = _c_neg[64];
    assign neg_out   = _neg[64];
    
    genvar i;
    generate for(i=0;i<64;i=i+1)
    begin: rba
        rba u_rba(
        .x_pos_in(x_pos_in[i]),
        .x_neg_in(x_neg_in[i]),
        .y_pos_in(y_pos_in[i]),
        .y_neg_in(y_neg_in[i]),
        .c_pos_in(_c_pos[i]),
        .c_neg_in(_c_neg[i]),
        .neg_in(_neg[i]),
        .c_pos_out(_c_pos[i+1]),
        .c_neg_out(_c_neg[i+1]),
        .z_pos_out(z_pos_out[i]),
        .z_neg_out(z_neg_out[i]),
        .neg_out(_neg[i+1])
        );
    end
    endgenerate
endmodule
