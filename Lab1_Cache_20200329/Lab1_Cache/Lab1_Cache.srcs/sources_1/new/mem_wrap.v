`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Harbin Institute of Technology, Shenzhen
// Engineer: Bohan Hu 
// 
// Create Date: 2020/01/23 20:26:07
// Design Name: RAM with latency
// Module Name: ram_wrap
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mem_wrap
    # (parameter LATENCY = 10 )//�ò���
    (
    input clk,
    input reset,
    input rreq,
    input [10:0]raddr,
    output reg wait_data,
    output reg [31:0]rdata,
    output reg rvalid
    );

localparam   IDLE = 4'b0001, 
             WAIT = 4'b0010,
             BURST = 4'b0100,
             RESP = 4'b1000,
             burst_len = 2'd3;
wire rlast;              
reg [3:0] current_state, next_state;
always @(posedge clk)   begin
    if(reset)    begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end
reg [1:0] burst_cnt;
reg [10:0] raddr_latch;
reg [31:0] wait_count;
wire wait_end = (wait_count == LATENCY);
wire burst_end = (burst_cnt == burst_len);
assign rlast = burst_end & (current_state == BURST);
reg [10:0]addr_to_ram;
wire [7:0]data_from_ram;
reg [31:0] reg4b;
wire [31:0] reg4b_shift = { data_from_ram, reg4b[31:24], reg4b[23:16], reg4b[15:8] };

always @(*) begin
    case (current_state)    
        IDLE:   begin
            if(rreq)    begin
                next_state = WAIT;
            end else begin
                next_state = IDLE;
            end
        end
        WAIT:  begin
            if(wait_end)    begin
                next_state = BURST;
            end else begin
                next_state = WAIT;
            end
        end
        BURST:   begin
            if(burst_end)    begin
                next_state = RESP;
            end else begin
                next_state = BURST;
            end
        end
        RESP:   begin
            next_state = IDLE;
        end
    endcase
end


always @(posedge clk)   begin
    if(reset)    begin
        raddr_latch <= 0;
        burst_cnt <= 0;
        wait_count <= 0;
    end else begin
        if(current_state == IDLE)   begin
            raddr_latch <= raddr;
            burst_cnt <= 0;
            wait_count <= 0;
        end else if(current_state == WAIT && next_state == WAIT)  begin
            wait_count <= wait_count + 1;
            raddr_latch <= raddr_latch;
            burst_cnt <= 0;
        end else if(current_state == WAIT && next_state == BURST)  begin
            raddr_latch <= raddr_latch + 1;
            burst_cnt <= 0;
            wait_count <= 0;
        end else if(current_state == BURST)  begin
            raddr_latch <= raddr_latch + 1;
            burst_cnt <= burst_cnt + 1;
            wait_count <= 0;
        end else if(current_state == RESP)  begin
            raddr_latch <= raddr_latch;
            burst_cnt <= 0;
            wait_count <= 0;
        end
    end
end




always @(posedge clk)   begin
    if(reset)   begin
        reg4b <= 0;
    end else if((current_state == WAIT && next_state == BURST) || current_state == BURST ) begin
        reg4b <= reg4b_shift;
    end else begin
        reg4b <= 0;
    end
end

always @(*) begin
    case(current_state)
        IDLE:   begin
            addr_to_ram = 0;
            rdata = 0;
            rvalid = 0;
            wait_data = 0;
        end
        WAIT:  begin
            addr_to_ram = raddr_latch;
            rdata = 0;
            rvalid = 0;
            wait_data = 1;
        end
        BURST:   begin
            addr_to_ram = raddr_latch;
            rdata = 0;
            rvalid = 0;
            wait_data = 1;
        end
        RESP:   begin
            addr_to_ram = 0;
            rdata = reg4b;
            rvalid = 1;
            wait_data = 0;
        end
    endcase
end

blk_mem mm(.clka(clk),.addra(addr_to_ram),.dina(0),.wea(0),.douta(data_from_ram));

endmodule
