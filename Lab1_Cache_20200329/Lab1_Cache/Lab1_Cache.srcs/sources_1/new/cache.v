`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Cache���� ///////////////////////////////////////
// ӳ�䷽ʽ��ֱ������
// �����ֳ���1 Byte
// Cache���С��4 Bytes
// �����ַ��ȣ� 11 bit
// Cache������64 Lines * 4 Bytes/Line = 256 Bytes
// �滻���ԣ��ޣ�ֱ�����������滻���ԣ�
//////////////////////////////////////////////////////////////////////////////////


module cache(
    // ȫ���ź�
    input clk,
    input reset,
    // ��CPU���ķ����ź�
    input [10:0] raddr_from_cpu,     // CPU��Ķ���ַ
    input rreq_from_cpu,            // CPU���Ķ�����
    // ���²��ڴ�ģ�������ź�
    input [31:0] rdata_from_mem,     // �ڴ��ȡ������
    input rvalid_from_mem,          // �ڴ��ȡ���ݿ��ñ�־
    input wait_data_from_mem,
    // �����CPU���ź�
    output  [7:0] rdata_to_cpu,      // �����CPU������
    output  hit_to_cpu,              // �����CPU�����б�־
    // ������²��ڴ�ģ����ź�
    output rreq_to_mem,         // ������²��ڴ�ģ��Ķ�����
    output [10:0] raddr_to_mem  // ������²�ģ����׵�ַ
    );
parameter Ready=3'b000,Tag_check=3'b001,Hit=3'b010,Wait_Mem=3'b011,Refill=3'b100,Unhit=3'b101;
reg [2:0]currState = Ready;
reg [2:0]nextState = Ready;
reg [2:0]formerState = Ready;
wire [0:2]tag;//�����ֿ���
wire [5:0] cacheAddr;//Cache�ֿ��ַ
wire [1:0] inAddr;//Cache�ֿ��ڵ�ַ;
reg [35:0] dina;//blockmemory����������
wire [35:0] douta;//blockmemory���������
reg [7:0] dataout =0;//Ҫ�����cpu��һ���ֽ�
reg hitornot=0;//�Ƿ�����
//reg hitor = 0;// ״̬ת���Ƿ�����
reg rreq_to_mem1;         // ������²��ڴ�ģ��Ķ�����
reg [10:0] raddr_to_mem1;  // ������²�ģ����׵�ַ
reg timeEnough; //��־λ, ��ʾ�Ƿ��������һ�����ڵ��������
reg fillOver;//��־λ, ��ʾ������
reg [31:0] tempData;//�ݴ�������������
assign rdata_to_cpu = dataout;
assign hit_to_cpu = hitornot;
assign rreq_to_mem = rreq_to_mem1;
assign raddr_to_mem = raddr_to_mem1;
reg wea;
wire hitor;
assign hitor =(douta[35] && douta[34:32] == tag) ? 1'b1 : 1'b0;

//???????
always @ (*)
begin   
    case(currState)
        Ready: if(rreq_from_cpu) begin nextState <= Tag_check;end else begin nextState <= Ready;end
        Tag_check: if(hitor)  begin nextState <= Hit;end else begin nextState <= Wait_Mem;end 
        Hit: if(hitornot) nextState <= Ready; else nextState <= Hit;
        Wait_Mem: if(!rvalid_from_mem) nextState <= Wait_Mem; else begin nextState <= Refill;  tempData <= rdata_from_mem;end //�����ݴ浽tempdata , ��Ϊ����ֻ��һ������
        Refill: if(fillOver) nextState <= Hit; else nextState <= Refill;
 //       Unhit: if(timeEnough) nextState <= Ready; else nextState <= Unhit;
    endcase
end


    assign tag =  raddr_from_cpu[10:8];
    assign cacheAddr = raddr_from_cpu[7:2];
    assign inAddr = raddr_from_cpu[1:0];


blk_mem_gen_0 cache1 (
  .clka(clk),    // input wire clka
  .wea(wea),      // input wire [0 : 0] wea
  .addra(cacheAddr),  // input wire [5 : 0] addra
  .dina(dina),    // input wire [35 : 0] dina   
  .douta(douta)  // output wire [35 : 0] douta
);


always @(posedge clk)//����յ�cpu �Ķ�����
begin
    formerState<= currState;
    currState <= (reset)?(Ready):(nextState);
    case(currState)
        Ready: begin 
        wea<=0;

        hitornot <= 0;
        fillOver <= 0;
        //hitor<=0;
         end
        Tag_check: begin 
         end
        Hit: 
        begin 

             hitornot <= 1;
             case(inAddr)
                2'b00: dataout <= douta[7:0];
                2'b01: dataout <= douta[15:8];
                2'b10: dataout <= douta[23:16];
                2'b11: dataout <= douta[31:24];
            endcase;
        end
        Wait_Mem: begin 
            rreq_to_mem1 <=1;
            raddr_to_mem1 <= raddr_from_cpu;
        end
        Refill: begin 
            rreq_to_mem1 <=0;
            wea<=1;
            dina[35:35] <= 1'b1;  //���´�����Ӧ�ı�ǩ, д��cache��
            dina[34:32] <= raddr_from_cpu[10:8];
            dina[31:0]<= tempData; //???????????????dina,��??cache
            fillOver <= 1;
        end
//        Unhit:
//        begin
//              hitornot <= 1;
//              timeEnough <= 1;
//             case(inAddr)
//                2'b00: dataout <= dina[7:0];
//                2'b01: dataout <= dina[15:8];
//                2'b10: dataout <= dina[23:16];
//                2'b11: dataout <= dina[31:24];
//            endcase
//            end
    endcase
  end  





endmodule
