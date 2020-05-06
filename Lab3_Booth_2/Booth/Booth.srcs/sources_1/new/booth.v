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
     input clk,        // ʱ���ź�
     input [7:0] x,    // ����
     input [7:0] y,    // ������
     input start,      // ��������ź�
     output [15:0] z,  // ��
     output busy       // ��������ź�
     );
    
     reg [19:0] result=20'b0;  //{2'b����λ,7'b x������, 8'b y������, 1'b yn+1, 1'b yn+2}
     wire [19:0] temp_result;
     assign z = result[17:2];
     reg [3:0] count=4'd0;
     reg [9:0] x_neg; //����-x�Ĳ���
     reg [9:0] x_pos; //����x�Ĳ���
     assign busy = (start==1 || count<4)?1:0;
     assign temp_result = result>>2;  //����ϵ�·ֱ�Ӹ���result ������2λ����ֵ
    wire [9:0]temp_x = {x[7],x[7],x};

     always@(posedge clk)
     begin
         if(start) //��ʼ��
         begin
             x_pos <= {x[7],x[7],x};
             x_neg <= ~temp_x+ 1;
             count <= 0;
             result<= {10'b0,y,2'b0}; //result ���������2λ,��Ϊyn+1��yn+2, ����Ϳ����������λ�����ж���Ӧ�üӻ��Ǽ�,������λ
         end
         else if(busy) //��ֹ�ظ���ֵ
         begin
             count<=count+1; //��������1
             case(result[3:1])
                 3'b00:
                 begin
                     result[17:0]<= temp_result[17:0]; //ֻ��ֵ��17λ��ֵ, �������λ����λ����, ʵ��������λ
                 end
                 3'b01:
                 begin
                     result[17:8]<=(temp_result[17:8]+x_pos);
                     result[7:0] <= temp_result[7:0];
                     result[19:18] <= ((temp_result[17:8]+x_pos) & 9'b100000000) ?2'b11:2'b00; //����Ӻ�����λ�� result, ��Ϊ�´���λ�ķ���λ, ʵ��������λ
                 end
                 3'b10:
                 begin
                    result[17:8]<=(temp_result[17:8]+x_pos);
                    result[7:0] <= temp_result[7:0];
                    result[19:18] <= ((temp_result[17:8]+x_pos) & 9'b100000000) ?2'b11:2'b00; //����Ӻ�����λ�� result, ��Ϊ�´���λ�ķ���λ, ʵ��������λ
                 end
                 3'b11:
                 begin
                    result[17:8]<=(temp_result[17:8]+x_pos+x_pos);
                    result[7:0] <= temp_result[7:0];
                    result[19:18] <= ((temp_result[17:8]+x_pos+x_pos) & 9'b100000000) ?2'b11:2'b00; //����Ӻ�����λ�� result, ��Ϊ�´���λ�ķ���λ, ʵ��������λ
                    
                 end
                 3'b100:
                 begin
                    result[17:8]<=(temp_result[17:8]+x_neg+x_neg);
                    result[7:0] <= temp_result[7:0];
                    result[19:18] <= ((temp_result[17:8]+x_neg+x_neg) & 9'b100000000) ?2'b11:2'b00; //����Ӻ�����λ�� result, ��Ϊ�´���λ�ķ���λ, ʵ��������λ
                 end
                3'b101:
                 begin
                    result[17:8]<=(temp_result[17:8]+x_neg);
                    result[7:0] <= temp_result[7:0];
                    result[19:18] <= ((temp_result[17:8]+x_neg) & 9'b100000000) ?2'b11:2'b00; //����Ӻ�����λ�� result, ��Ϊ�´���λ�ķ���λ, ʵ��������λ
                 end
                3'b110:
                 begin
                    result[17:8]<=(temp_result[17:8]+x_neg);
                    result[7:0] <= temp_result[7:0];
                    result[19:18] <= ((temp_result[17:8]+x_neg) & 9'b100000000) ?2'b11:2'b00; //����Ӻ�����λ�� result, ��Ϊ�´���λ�ķ���λ, ʵ��������λ
                 end
                3'b111:
                 begin
                     result[17:0]<= temp_result[17:0]; //ֻ��ֵ��16λ��ֵ, �������λ����λ����, ʵ��������λ
                 end
             endcase
         end
        
        
     end
 endmodule

