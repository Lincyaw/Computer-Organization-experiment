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
    
     reg [19:0] result=20'b0;  //{2'b符号位,7'b x的数据, 8'b y的数据, 1'b yn+1, 1'b yn+2}
     wire [19:0] temp_result;
     assign z = result[17:2];
     reg [3:0] count=4'd0;
     reg [9:0] x_neg; //保存-x的补码
     reg [9:0] x_pos; //保存x的补码
     assign busy = (start==1 || count<4)?1:0;
     assign temp_result = result>>2;  //用组合电路直接给出result 的右移2位的数值
    wire [9:0]temp_x = {x[7],x[7],x};

     always@(posedge clk)
     begin
         if(start) //初始化
         begin
             x_pos <= {x[7],x[7],x};
             x_neg <= ~temp_x+ 1;
             count <= 0;
             result<= {10'b0,y,2'b0}; //result 增加了最后2位,作为yn+1和yn+2, 后面就可以用最后两位用来判断是应该加还是减,还是移位
         end
         else if(busy) //防止重复赋值
         begin
             count<=count+1; //计数器加1
             case(result[3:1])
                 3'b00:
                 begin
                     result[17:0]<= temp_result[17:0]; //只赋值后17位的值, 保持最高位符号位不变, 实现算术移位
                 end
                 3'b01:
                 begin
                     result[17:8]<=(temp_result[17:8]+x_pos);
                     result[7:0] <= temp_result[7:0];
                     result[19:18] <= ((temp_result[17:8]+x_pos) & 9'b100000000) ?2'b11:2'b00; //把相加后的最高位给 result, 作为下次移位的符号位, 实现算术移位
                 end
                 3'b10:
                 begin
                    result[17:8]<=(temp_result[17:8]+x_pos);
                    result[7:0] <= temp_result[7:0];
                    result[19:18] <= ((temp_result[17:8]+x_pos) & 9'b100000000) ?2'b11:2'b00; //把相加后的最高位给 result, 作为下次移位的符号位, 实现算术移位
                 end
                 3'b11:
                 begin
                    result[17:8]<=(temp_result[17:8]+x_pos+x_pos);
                    result[7:0] <= temp_result[7:0];
                    result[19:18] <= ((temp_result[17:8]+x_pos+x_pos) & 9'b100000000) ?2'b11:2'b00; //把相加后的最高位给 result, 作为下次移位的符号位, 实现算术移位
                    
                 end
                 3'b100:
                 begin
                    result[17:8]<=(temp_result[17:8]+x_neg+x_neg);
                    result[7:0] <= temp_result[7:0];
                    result[19:18] <= ((temp_result[17:8]+x_neg+x_neg) & 9'b100000000) ?2'b11:2'b00; //把相加后的最高位给 result, 作为下次移位的符号位, 实现算术移位
                 end
                3'b101:
                 begin
                    result[17:8]<=(temp_result[17:8]+x_neg);
                    result[7:0] <= temp_result[7:0];
                    result[19:18] <= ((temp_result[17:8]+x_neg) & 9'b100000000) ?2'b11:2'b00; //把相加后的最高位给 result, 作为下次移位的符号位, 实现算术移位
                 end
                3'b110:
                 begin
                    result[17:8]<=(temp_result[17:8]+x_neg);
                    result[7:0] <= temp_result[7:0];
                    result[19:18] <= ((temp_result[17:8]+x_neg) & 9'b100000000) ?2'b11:2'b00; //把相加后的最高位给 result, 作为下次移位的符号位, 实现算术移位
                 end
                3'b111:
                 begin
                     result[17:0]<= temp_result[17:0]; //只赋值后16位的值, 保持最高位符号位不变, 实现算术移位
                 end
             endcase
         end
        
        
     end
 endmodule

