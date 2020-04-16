`timescale 1ns / 1ps
//根据输入的BS和BR信号，决定是否给出BG信号
module controller_link(
    input BS,BR,
    output BG
    );

    assign BG = BR?1'b1:1'b0;
endmodule
