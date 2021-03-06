`timescale 1ns / 1ps
`define  NOP          4'b0000
`define  LOAD         4'b0010
`define  STORE        4'b0011
`define  MOVE         4'b0100
`define  ADD          4'b0101
`define  AND          4'b0110
`define  JUMP         4'b0111
`define  JUMPZ        4'b1000
`define  JUMPNZ        4'b1001
`define  LOADR         4'b1010

module Control_Unit(
    input clk,
    input reset,
    input [7:0] IR,
    input ZF,
    output PC_i, IR_i, MAR_i, MDR_i, ACC_i, SP_i, R_i,
    output PC_o, MDR_o, ACC_o, SP_o, R_o,
    output PC_Sel, MDR_Sel, ACC_Sel,
    output ALU_Sel,
    output MemRead, MemWrite
    );

reg [31:0] ucode_mem [255:0];
reg [255:0] uPC=0;
reg [31:0] curr_code;
initial begin
    $readmemb("microcode.txt", ucode_mem);
end

assign PC_i = curr_code[29];
assign IR_i = curr_code[28];
assign MAR_i = curr_code[27];
assign MDR_i = curr_code[26];
assign ACC_i = curr_code[25];
assign SP_i = curr_code[24];
assign R_i = curr_code[23];
assign PC_o = curr_code[22];
assign MDR_o = curr_code[21];
assign ACC_o = curr_code[20];
assign SP_o  = curr_code[19];
assign R_o = curr_code[18];
assign PC_Sel = curr_code[17];
assign MDR_Sel = curr_code[16];
assign ACC_Sel = curr_code[15];
assign ALU_Sel = curr_code[14];
assign MemRead = curr_code[13];
assign MemWrite = curr_code[12];
wire condJMP = curr_code[11];
wire condSel = curr_code[10];
wire [1:0]nextAddrSel = curr_code[9:8];
wire [7:0]addr = curr_code[7:0];
reg [7:0] nextAddress=0;
// always@(*)//那个啥玩意MUX
// begin 
//     curr_code = ucode_mem[uPC];//取出微指令
//     if(nextAddrSel==2'b00)
//     begin
//         nextAddress <= uPC+1;
//     end
//     else if(nextAddrSel==2'b01)
//     begin
//         nextAddress <= addr;
//     end
//     else
//     begin
//         case (IR[7:4])
//         4'b0000: begin
//             nextAddress <= 8'h1c;
//         end
//         4'b0010:begin
//             nextAddress <= 8'h7;
//         end
//         4'b0011:begin
//             nextAddress <= 8'hc;
//         end
//         4'b0100:begin
//             nextAddress <= 8'h10;
//         end
//         4'b0101:begin
//             nextAddress <= 8'h11;
//         end
//         4'b0110:begin
//             nextAddress <= 8'h12;
//         end
//         4'b0111:begin
//             nextAddress <= 8'h13;
//         end
//         4'b1000:begin
//             nextAddress <= 8'h16;
//         end
//         4'b1001:begin
//             nextAddress <= 8'h19;
//         end
//         4'b1010:begin
//             nextAddress <= 8'h4;
//         end
//         default: begin
//             nextAddress <= 8'h0;
//         end
//     endcase
//     end
// end

always@(*)//那个啥玩意MUX
begin
    curr_code = ucode_mem[uPC];//取出微指令

        case (IR[7:4])
        4'b0000: begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'h1c;
            end
        end
        4'b0010:begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'h7;
            end
        end
        4'b0011:begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'hc;
            end
            
        end
        4'b0100:begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'h10;
            end
            
        end
        4'b0101:begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'h11;
            end
            
        end
        4'b0110:begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'h12;
            end
            
        end
        4'b0111:begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'h13;
            end
            
        end
        4'b1000:begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'h16;
            end
        end
        4'b1001:begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'h19;
            end
        end
        4'b1010:begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'h4;
            end
        end
        default: begin
            if(nextAddrSel==2'b00)
            begin
                nextAddress <= uPC+1;
            end
            else if(nextAddrSel==2'b01)
            begin
                nextAddress <= addr;
            end
            else
            begin
                nextAddress <= 8'h0;
            end
        end
    endcase
    
end

always@(posedge clk)
begin
    if(reset)
    begin
        uPC<=addr;
    end
    else if (condJMP==1&&condSel==0&&ZF==0) begin//jz,但是不为0,就回到取指
        uPC<=addr;
    end
    else if(condJMP==1&&condSel==1&&ZF==1)begin//jnz,但是为0,就回到取指
        uPC<=addr;
    end
    else
    begin
        uPC<=nextAddress;
    end
end

endmodule
