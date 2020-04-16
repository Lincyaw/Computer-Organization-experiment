`timescale 1ns / 1ps

module controller_counter(
    input clk,              // ʱ��
    input rst,              // ��λ
    input BR,               // ����������
    input BS,               // ���߷�æ�ź�
    input mode,             // ����ģʽ
    // 1������ֹ�㿪ʼ��ѭ��ģʽ��0���ӹ̶�ֵ��ʼ�Ĺ̶����ȼ�ģʽ
    input [1:0] cnt_rstval, // �������ĸ�λֵ
    output reg [1:0] cnt    // �����������ֵ
    );
    reg temp=0;
    always@(posedge clk)
    begin
        if(rst) cnt<=cnt_rstval;
        else
        begin
        case(mode)
            1'b0:
            begin
                if(!BS&BR)//�����æ����������
                begin
                  cnt <=temp?cnt_rstval:cnt+1;//���temp��1,�����߼��Ǿ�Ҫ�ص���ʼֵ
                  temp <= temp?0:temp;//������temp��0,��ʾ�Ѿ��ص���ʼֵ
                end
                else
                begin//�ȿ�����,���������æ����û���� ��ô����tempΪ1, ��ʾ��Ҫ����������Ѿ�������һ���豸
                  cnt <= cnt;
                  temp <= 1;
                end
            end
            1'b1:
            begin
                cnt <= (!BS&BR)? cnt+1 : cnt;

            end
        endcase
        end

    end



endmodule
