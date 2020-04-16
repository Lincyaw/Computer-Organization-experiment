`timescale 1ns / 1ps

module io_interface_counter(
    input clk,
    input rst,
    input   BR_in,              // �ⲿ�������������
    output  BR_out,         // ��������������ź�
    output  BS_out,             // ���������æ�ź�
    input   [3:0]din,           // �����ַ���ⲿ����
    output  [3:0]dout,          // ���ڵ�ַ�����ϵ�����
    input   [1:0] device_id,    // �豸��ַ�����ã�
    input   [1:0] cnt_in        // ����������
    );

// ��ʹ������ʱ�������������̬��z)
    //���BR_in˵���Լ�Ҫ����BR_out�ź�
    reg BS_temp;
     
    assign dout = BS_out ? din:4'bzzzz; 	
    assign BR_out = BR_in;
    //assign BS_out = BS_temp;
    assign BS_out = (device_id == cnt_in && BR_in)? 1'b1:1'b0;
    // always@(posedge clk)
    // begin
    //     BS_temp = (device_id == cnt_in && BR_in)? 1'b1:1'b0;

    // end
    
endmodule
