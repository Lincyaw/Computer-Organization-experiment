`timescale 1ns / 1ps

module controller_counter(
    input clk,              // 时钟
    input rst,              // 复位
    input BR,               // 总线请求线
    input BS,               // 总线繁忙信号
    input mode,             // 计数模式
    // 1：从终止点开始的循环模式，0：从固定值开始的固定优先级模式
    input [1:0] cnt_rstval, // 计数器的复位值
    output reg [1:0] cnt    // 计数器的输出值
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
                if(!BS&BR)//如果不忙而且有需求
                begin
                  cnt <=temp?cnt_rstval:cnt+1;//如果temp是1,按照逻辑那就要回到初始值
                  temp <= temp?0:temp;//并且让temp置0,表示已经回到初始值
                end
                else
                begin//先看这里,如果总线在忙或者没需求 那么就让temp为1, 表示快要处理完或者已经处理完一个设备
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
