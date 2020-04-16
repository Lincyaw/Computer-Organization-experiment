`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/04 14:42:32
// Design Name: 
// Module Name: sim_rbbe4_top
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


module sim_rbbe4_top(
    );
    `define X_POS 32'd233
    `define Y_POS 32'd666
    `define Z_POS 32'd155178
    `define X_NEG ~`X_POS+1'b1
    `define Y_NEG ~`Y_POS+1'b1
    `define Z_NEG ~`Z_POS+1'b1
    reg [31:0] x_in;
    reg [31:0] y_in;
    wire [63:0] z_out;
    reg [63:0] z_ans;
    rbbe4 u_rbbe4(.x_in(x_in), .y_in(y_in), .z_out(z_out));
    initial begin
        x_in<=`X_POS;
        y_in<=`Y_POS;
        z_ans<=`Z_POS;
        #20
        x_in<=`X_POS;
        y_in<=`Y_NEG;
        z_ans<=`Z_NEG;
        #20
        x_in<=`X_NEG;
        y_in<=`Y_POS;
        z_ans<=`Z_NEG;
        #20
        x_in<=`X_NEG;
        y_in<=`Y_NEG;
        z_ans<=`Z_POS;
        #20 $finish;
    end
endmodule