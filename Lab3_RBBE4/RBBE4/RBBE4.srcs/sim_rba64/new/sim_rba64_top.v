`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/03 21:51:50
// Design Name: 
// Module Name: sim_rba64_top
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


module sim_rba64_top();
    reg [63:0] x_pos_in;
    reg [63:0] x_neg_in;
    reg [63:0] y_pos_in;
    reg [63:0] y_neg_in;
    reg c_pos_in = 0;
    reg c_neg_in = 0;
    reg neg_in = 0;
    wire c_pos_out;
    wire c_neg_out;
    wire [63:0] z_pos_out;
    wire [63:0] z_neg_out;
    wire neg_out;
    
    reg [63:0] z_pos_ans;
    reg [63:0] z_neg_ans;
    
    initial begin
        //     1 0 -1 0 -1 0 0 -1
        x_pos_in <={54'b0, 8'b10000000};
        x_neg_in <={54'b0, 8'b00101001};
        // +   1 -1 1 0 0 1 1 -1
        y_pos_in <={54'b0, 8'b10100110};
        y_neg_in <={54'b0, 8'b01000001};
        y_pos_in<=64'b0;
        y_neg_in<=64'b0;
        // =  1 -1 1 0 0 0 -1 0 0
        z_pos_ans<={53'b0,9'b101000000};
        z_neg_ans<={53'b0,9'b010000100};
        #20 $finish;
    end
    
    rba64 u_rba64(
    .x_pos_in(x_pos_in),
    .x_neg_in(x_neg_in),
    .y_pos_in(y_pos_in),
    .y_neg_in(y_neg_in),
    .c_pos_in(c_pos_in),
    .c_neg_in(c_neg_in),
    .neg_in(neg_in),
    .c_pos_out(c_pos_out),
    .c_neg_out(c_neg_out),
    .z_pos_out(z_pos_out),
    .z_neg_out(z_neg_out),
    .neg_out(neg_out)
    );
endmodule
