`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 11:04:04 AM
// Design Name: 
// Module Name: rsa_encrypt
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


module rsa_encrypt(
    input clk,
    input rst,
    input [31:0] plaintext,
    input [31:0] n,
    input [31:0] e,
    input start,
    output reg [31:0] ciphertext,
    output reg done
    );
reg [1:0] state;
reg [31:0] result ;
reg [31:0] base;
reg [31:0] exp_reg;
reg [63:0] product;

parameter IDLE = 2'b00 , ENCRYPT = 2'b01 , FINISH = 2'b10 ;
always@(posedge clk or posedge rst) begin
    if(rst) begin
        state      <= IDLE ;
        result     <= 0;
        base       <= 0;
        exp_reg    <= 0;
        done       <= 1'b0;
        ciphertext <= 0;
        product    <= 0;
        $display("Reset at %t", $time);
    end else begin
        case(state)
        IDLE : begin
            done <= 1'b0;
            if(start) begin
                base     <= plaintext % n;
                exp_reg  <= e;
                result   <= 1 % n;
                state    <= ENCRYPT;
            end
        end
        
        ENCRYPT : begin
            if(exp_reg == 0) begin
                ciphertext   <= result;
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

