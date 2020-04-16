`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/02 11:02:56
// Design Name: 
// Module Name: booth
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


module booth(
    input clk,        // 时钟信号
    input [7:0] x,    // 乘数
    input [7:0] y,    // 被乘数
    input start,      // 输入就绪信号
    output [15:0] z,  // 积
    output busy       // 输出就绪信号
    );
    
    // 在此处编写你的代码
   

    reg temp_y=0;
    reg [16:0] result=17'b0;
    wire [16:0] temp_result;
    assign z = result[16:1];
    reg [3:0] count=4'd0;
    reg [7:0] x_neg; //保存-x的补码
    reg [7:0] x_pos; //保存x的补码
    reg [7:0] y_data;//保存y的补码
    assign busy = (start==1 || count<8)?1:0;
    assign temp_result = result>>1;  //用组合电路直接给出result 的右移一位的数值


    always@(posedge clk)
    begin
        if(start) //初始化
        begin
            x_pos <= x;
            x_neg <= ~x+ 1;
            count <= 0;
            result<= {8'b0,y,1'b0}; //result 增加了最后一位,作为yn+1, 后面就可以用最后两位用来判断是应该加还是减,还是移位
        end
        else if(busy) //防止重复赋值
        begin
            count<=count+1; //计数器加1
            case(result[1:0])
                2'b00:
                begin
                    result[15:0]<= temp_result[15:0]; //只赋值后16位的值, 保持最高位符号位不变, 实现算术移位
                end
                2'b01:
                begin
                    result[15:8]<=(temp_result[15:8]+x_pos);
                    result[7:0] <= temp_result[7:0];
                    result[16] <= ((temp_result[15:8]+x_pos) & 8'b10000000) ?1:0; //把相加后的最高位给 result, 作为下次移位的符号位, 实现算术移位
                end
                2'b10:
                begin
                    result[15:8]<=(temp_result[15:8]+x_neg);
                    result[7:0] <= temp_result[7:0];
                    result[16] <= ((temp_result[15:8]+x_neg) &8'b10000000) ?1:0; //把相加后的最高位给 result, 作为下次移位的符号位, 实现算术移位
                end
                2'b11:
                begin
                    result[15:0]<= temp_result[15:0];//只赋值后16位的值, 保持最高位符号位不变, 实现算术移位
                end
            endcase
        end
        
        
    end
endmodule
