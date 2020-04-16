`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Cache参数 ///////////////////////////////////////
// 映射方式：直接相联
// 数据字长：1 Byte
// Cache块大小：4 Bytes
// 主存地址宽度： 11 bit
// Cache容量：64 Lines * 4 Bytes/Line = 256 Bytes
// 替换策略：无（直接相联，无替换策略）
//////////////////////////////////////////////////////////////////////////////////


module cache(
    // 全局信号
    input clk,
    input reset,
    // 从CPU来的访问信号
    input [10:0] raddr_from_cpu,     // CPU來的读地址
    input rreq_from_cpu,            // CPU来的读请求
    // 从下层内存模块来的信号
    input [31:0] rdata_from_mem,     // 内存读取的数据
    input rvalid_from_mem,          // 内存读取数据可用标志
    input wait_data_from_mem,
    // 输出给CPU的信号
    output  [7:0] rdata_to_cpu,      // 输出给CPU的数据
    output  hit_to_cpu,              // 输出给CPU的命中标志
    // 输出给下层内存模块的信号
    output rreq_to_mem,         // 输出给下层内存模块的读请求
    output [10:0] raddr_to_mem  // 输出给下层模块的首地址
    );
parameter Ready=3'b000,Tag_check=3'b001,Hit=3'b010,Wait_Mem=3'b011,Refill=3'b100,Unhit=3'b101;
reg [2:0]currState = Ready;
reg [2:0]nextState = Ready;
reg [2:0]formerState = Ready;
wire [0:2]tag;//主存字块标记
wire [5:0] cacheAddr;//Cache字块地址
wire [1:0] inAddr;//Cache字块内地址;
reg [35:0] dina;//blockmemory的输入数据
wire [35:0] douta;//blockmemory的输出数据
reg [7:0] dataout =0;//要输出给cpu的一个字节
reg hitornot=0;//是否命中
//reg hitor = 0;// 状态转移是否命中
reg rreq_to_mem1;         // 输出给下层内存模块的读请求
reg [10:0] raddr_to_mem1;  // 输出给下层模块的首地址
reg timeEnough; //标志位, 表示是否持续够了一个周期的数据输出
reg fillOver;//标志位, 表示填充完毕
reg [31:0] tempData;//暂存主存来的数据
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
        Wait_Mem: if(!rvalid_from_mem) nextState <= Wait_Mem; else begin nextState <= Refill;  tempData <= rdata_from_mem;end //把数据存到tempdata , 因为数据只有一个周期
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


always @(posedge clk)//如果收到cpu 的读请求
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
            dina[35:35] <= 1'b1;  //重新打上相应的标签, 写入cache中
            dina[34:32] <= raddr_from_cpu[10:8];
            dina[31:0]<= tempData; //???????????????dina,д??cache
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
