`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 11:05:41 AM
// Design Name: 
// Module Name: rsa_decrypt
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



module rsa_decrypt(
    input clk,
    input rst,
    input [31:0] ciphertext,
    input [31:0] n,
    input [31:0] d,
    input start,
    output reg [31:0] plaintext,
    output reg done
    );
reg [1:0] state;
reg [31:0] result ;
reg [31:0] base;
reg [31:0] exp_reg;
reg [63:0] product;


parameter IDLE = 2'b00 , DECRYPT = 2'b01 , FINISH = 2'b10 ;
always@(posedge clk or posedge rst) begin
    if(rst) begin
        state      <= IDLE ;
        result     <= 0;
        base       <= 0;
        exp_reg    <= 0;
        done       <= 1'b0;
        plaintext <= 0;
        product    <= 0;
        $display("Reset at %t", $time);
    end else begin
        case(state)
        IDLE : begin
            done <= 1'b0;
            if(start) begin
                base     <= ciphertext % n;
                exp_reg  <= d;
                result   <= 1 % n;
                state    <= DECRYPT;
            end
        end
        
        DECRYPT : begin
            if(exp_reg == 0) begin
                plaintext   <= result;
                done         <= 1'b1;
                state        <= FINISH;
            end else begin
                if (exp_reg[0]) begin
                    product  = result * base;
                    result   <= product % n;
                end
                product  = base * base;
                base     <= product % n;
                exp_reg  <= exp_reg >> 1;
            end 
        end
        
        FINISH : begin
            state <= IDLE;
        end  
        default : begin
            state <= IDLE;
        end 
        endcase 
    end 
end    
endmodule
