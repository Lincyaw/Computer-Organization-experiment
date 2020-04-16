`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/03 19:31:20
// Design Name: 
// Module Name: sim_rb2nb
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


module sim_rb2nb_top(

    );
    reg [63:0] r_pos_in;
    reg [63:0] r_neg_in;
    wire c_out;
    wire [63:0] r_out;
    wire [63:0] r_ans = r_pos_in + ~r_neg_in + 1'b1;
    
    rb2nb u_rb2nb(.r_pos_in(r_pos_in), .r_neg_in(r_neg_in), .c_out(c_out), .r_out(r_out));

    initial begin
        r_pos_in=64'b0010;
        r_neg_in=64'b1001;
        #20 $finish;
    end
endmodule
