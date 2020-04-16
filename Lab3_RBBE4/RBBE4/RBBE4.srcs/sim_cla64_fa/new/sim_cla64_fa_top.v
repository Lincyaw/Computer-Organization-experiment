`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/03 17:33:20
// Design Name: 
// Module Name: sim_cla64_fa_top
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


module sim_cla64_fa_top(

    );
    reg [63:0] a;
    reg [63:0] b;
    wire [63:0] s_ans = a+b;
    wire c_in = 1'b0;
    wire c_out,g_out,p_out;
    wire [63:0] s;
    
    cla64_fa u_cla64_fa(.a_in(a), .b_in(b), .c_in(c_in), .c_out(c_out), .g_out(g_out), .p_out(p_out), .s_out(s));

    initial begin
        a=64'd2;
        b=64'd10;
        #20  a=~(64'd2)+64'd1;
        b=64'd10;
        #20 $finish;
    end
endmodule
