`timescale 1ns / 1ps
// �����������ź������������
// �ж��Լ��Ƿ����ʹ������
// �������ݵ������ȷ������ͻʹ������
// ����BG�źŵĴ���


module io_interface_link(
    input BG_in, // �������豸������BG�ź�
    output BG_out, // �������豸��BG�źţ���ʽ��
    input BR_in,    // �ⲿ�������������
    output BR_out,  // ��������������ź�
    output BS_out,  // ���������æ�ź�
    input [3:0]din, // �����ַ���ⲿ����
    output [3:0]dout    // ���ڵ�ַ�����ϵ�����
    );
    reg temp_BG_out;
    //���BR_in˵���Լ�Ҫ����BR_out�ź�
    assign BR_out = BR_in;
    //���BR_in&BG_in,��˵����������������,��������ͬ����, �Ǿ�Ҫ��������ͳһ�ź�,�����������æ
    assign BS_out = BR_in & BG_in ? 1'b1:1'b0;
    assign BG_out= temp_BG_out;//����Ҫ����BG�ź�
    
    always@*
    begin
        if(BR_in & BG_in)
        begin
            temp_BG_out = 1'b0;
        end
        else if(!BG_in)
        begin
            temp_BG_out = BG_in;
        end
        else
        begin
            temp_BG_out = 1'b1;
        end
    end
    assign dout = BR_in & BG_in ? din: 4'bzzzz;//�����������������

endmodule
