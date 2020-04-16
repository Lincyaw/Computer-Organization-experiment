`timescale 1ns / 1ps

module io_interface_counter(
    input clk,
    input rst,
    input   BR_in,              // 外部输入的总线请求
    output  BR_out,         // 输出：总线请求信号
    output  BS_out,             // 输出：总线忙信号
    input   [3:0]din,           // 请求地址：外部输入
    output  [3:0]dout,          // 放在地址总线上的数据
    input   [1:0] device_id,    // 设备地址（配置）
    input   [1:0] cnt_in        // 计数器输入
    );

// 不使用总线时，必须输出高阻态（z)
    //如果BR_in说明自己要发出BR_out信号
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
