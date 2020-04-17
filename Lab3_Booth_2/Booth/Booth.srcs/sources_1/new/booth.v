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
    
   

     reg temp_y=0;
     reg [16:0] result=17'b0;
     wire [16:0] temp_result;
     assign z = result[16:1];
     reg [3:0] count=4'd0;
     reg [7:0] x_neg; //����-x�Ĳ���
     reg [7:0] x_pos; //����x�Ĳ���
     reg [7:0] y_data;//����y�Ĳ���
     assign busy = (start==1 || count<8)?1:0;
     assign temp_result = result>>1;  //����ϵ�·ֱ�Ӹ���result ������һλ����ֵ


     always@(posedge clk)
     begin
         if(start) //��ʼ��
         begin
             x_pos <= x;
             x_neg <= ~x+ 1;
             count <= 0;
             result<= {8'b0,y,1'b0}; //result ���������һλ,��Ϊyn+1, ����Ϳ����������λ�����ж���Ӧ�üӻ��Ǽ�,������λ
         end
         else if(busy) //��ֹ�ظ���ֵ
         begin
             count<=count+1; //��������1
             case(result[1:0])
                 2'b00:
                 begin
                     result[15:0]<= temp_result[15:0]; //ֻ��ֵ��16λ��ֵ, �������λ����λ����, ʵ��������λ
                 end
                 2'b01:
                 begin
                     result[15:8]<=(temp_result[15:8]+x_pos);
                     result[7:0] <= temp_result[7:0];
                     result[16] <= ((temp_result[15:8]+x_pos) & 8'b10000000) ?1:0; //����Ӻ�����λ�� result, ��Ϊ�´���λ�ķ���λ, ʵ��������λ
                 end
                 2'b10:
                 begin
                     result[15:8]<=(temp_result[15:8]+x_neg);
                     result[7:0] <= temp_result[7:0];
                     result[16] <= ((temp_result[15:8]+x_neg) &8'b10000000) ?1:0; //����Ӻ�����λ�� result, ��Ϊ�´���λ�ķ���λ, ʵ��������λ
                 end
                 2'b11:
                 begin
                     result[15:0]<= temp_result[15:0];//ֻ��ֵ��16λ��ֵ, �������λ����λ����, ʵ��������λ
                 end
             endcase
         end
        
        
     end
 endmodule




//module booth(
//    input clk,        // ʱ���ź�
//    input [7:0] x,    // ����
//    input [7:0] y,    // ������
//    input start,      // ��������ź�
//    output [15:0] z,  // ��
//    output busy       // ��������ź�
//    );
    
   

//    reg temp_y=0;
//    reg [16:0] result=17'b0;
//    wire [16:0] temp_result;
//    assign z = result[16:1];
//    reg [3:0] count=4'd0;
//    reg [7:0] x_neg; //����-x�Ĳ���
//    reg [7:0] x_pos; //����x�Ĳ���
//    reg [7:0] y_data;//����y�Ĳ���
//    assign busy = (start==1 || count<8)?1:0;
//    assign temp_result = result>>1;  //����ϵ�·ֱ�Ӹ���result ������һλ����ֵ

//    always@(posedge start)
//    begin
//        x_pos <= x;
//        x_neg <= ~x+ 1;
//        y_data <= y;
//    end

//    always@(posedge clk)
//    begin
//        if(start) //��ʼ��
//        begin
//            temp_y=0;
//            count <= 0;
//            result<= 17'b0; //result ���������һλ,��Ϊyn+1, ����Ϳ����������λ�����ж���Ӧ�üӻ��Ǽ�,������λ
//        end
//        else if(busy) //��ֹ�ظ���ֵ
//        begin
//            temp_y <= y_data[0];
//            count<=count+1; //��������1
//            y_data <= y_data >> 1;
//            if(temp_y==y_data[0])
//            begin
//                result[15:0]<= temp_result[15:0]; //ֻ��ֵ��16λ��ֵ, �������λ����λ����, ʵ��������λ
//            end
//            else if (temp_y)
//            begin
//                result[15:8]<=(temp_result[15:8]+x_pos);
//                result[7:0] <= temp_result[7:0];
//                result[16] <= ((temp_result[15:8]+x_pos) & 8'b10000000) ?1:0; //����Ӻ�����λ�� result, ��Ϊ�´���λ�ķ���λ, ʵ��������λ
//            end
//            else
//            begin           
//                result[15:8]<=(temp_result[15:8]+x_neg);
//                result[7:0] <= temp_result[7:0];
//                result[16] <= ((temp_result[15:8]+x_neg) &8'b10000000) ?1:0; //����Ӻ�����λ�� result, ��Ϊ�´���λ�ķ���λ, ʵ��������λ
//            end
        
//        end
        
        
//    end
//endmodule