`timescale 1ns / 1ps
// 将总线请求信号输出到控制器
// 判断自己是否可以使用总线
// 控制数据的输出，确保不冲突使用总线
// 控制BG信号的传递


module io_interface_link(
    input BG_in, // 由其他设备进来的BG信号
    output BG_out, // 给其他设备的BG信号（链式）
    input BR_in,    // 外部输入的总线请求
    output BR_out,  // 输出：总线请求信号
    output BS_out,  // 输出：总线忙信号
    input [3:0]din, // 请求地址：外部输入
    output [3:0]dout    // 放在地址总线上的数据
    );
    reg temp_BG_out;
    //如果BR_in说明自己要发出BR_out信号
    assign BR_out = BR_in;
    //如果BR_in&BG_in,就说明自身有总线请求,并且总线同意了, 那就要拦截总线统一信号,并且输出总线忙
    assign BS_out = BR_in & BG_in ? 1'b1:1'b0;
    assign BG_out= temp_BG_out;//并且要封锁BG信号
    
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
    assign dout = BR_in & BG_in ? din: 4'bzzzz;//还得向总线输出数据

endmodule
