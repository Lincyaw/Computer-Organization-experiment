`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/04 00:09:20
// Design Name: 
// Module Name: sim_booth4_top
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


module sim_booth4_top();
    reg [63:0] x_in;
    reg [4:0] y_in;
    wire [63:0] pp_pos_out;
    wire [63:0] pp_neg_out;
    reg [63:0] pp_pos_ans;
    reg [63:0] pp_neg_ans;
    initial begin
        x_in <= 64'd74;
        pp_pos_ans <= 64'd296; //   +4M
        pp_neg_ans <= 64'd74;  // - +1M
        y_in <= 5'b00110;      // = +3M
        #20 
        pp_pos_ans <= 64'd74;  //   +1M
        pp_neg_ans <= 64'd296; // - +4M
        y_in <= 5'b10110;      // = -3M
        #20 $finish;
    end
    booth4 u_booth4(.x_in(x_in), .y_in(y_in), .pp_pos_out(pp_pos_out), .pp_neg_out(pp_neg_out));
endmodule
