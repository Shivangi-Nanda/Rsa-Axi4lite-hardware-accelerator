`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 11:02:25 AM
// Design Name: 
// Module Name: rsa_axi_slave
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


module rsa_axi_slave(
    input clk,
    input rst,
    input [4:0] awaddr,
    input awvalid,
    output awready,
    input [31:0] wdata,
    input [3:0] wstrb,
    input wvalid,
    output wready,
    output [1:0] bresp,
    output bvalid,
    input bready,
    input [4:0] araddr,
    input arvalid,
    output arready,
    output reg [31:0] rdata,
    output [1:0] rresp,
    output rvalid,
    input rready,

    output reg [31:0] rsa_plaintext,
    output reg [31:0] rsa_n,
    output reg [31:0] rsa_e,
    output reg [31:0] rsa_d,
    output reg start_enc,
    output reg start_dec,
    input [31:0] rsa_ciphertext,
    input [31:0] rsa_decrypted,
    input done_enc,
    input done_dec
);

    reg [31:0] mem_write [0:3]; // plaintext, n, e, d
    reg [31:0] mem_result [0:1]; // ciphertext, decrypted
    reg [4:0] awaddr_reg;
    reg [31:0] wdata_reg;
    reg write_enable;

    assign awready = 1;
    assign wready  = 1;
    assign bresp   = 2'b00;
    assign bvalid  = 1;
    assign arready = 1;
    assign rresp   = 2'b00;
    assign rvalid  = 1;

    // Latch write address and data
    always @(posedge clk) begin
        if (rst) begin
            awaddr_reg <= 5'h0;
            wdata_reg <= 32'h0;
            write_enable <= 0;
        end else if (awvalid && wvalid) begin
            awaddr_reg <= awaddr;
            wdata_reg <= wdata;
            write_enable <= 1;
        end else begin
            write_enable <= 0;
        end
    end

    // Synchronous read
    always @(posedge clk) begin
        if (rst) begin
            rdata <= 32'h0;
        end else if (arvalid) begin
            case (araddr)
                5'h00: rdata <= mem_write[0]; // plaintext
                5'h04: rdata <= mem_write[1]; // n
                5'h08: rdata <= mem_write[2]; // e
                5'h0C: rdata <= mem_write[3]; // d
                5'h1E: rdata <= {31'h0, start_enc}; // Read back start_enc
                5'h1F: rdata <= {31'h0, start_dec}; // Read back start_dec
                5'h10: rdata <= mem_result[0]; // ciphertext
                5'h14: rdata <= mem_result[1]; // decrypted
                default: rdata <= 32'h00000000;
            endcase
        end
    end

    // Write logic and RSA signal updates
    always @(posedge clk) begin
        if (rst) begin
            start_enc <= 0;
            start_dec <= 0;
            rsa_plaintext <= 0;
            rsa_n <= 0;
            rsa_e <= 0;
            rsa_d <= 0;
        end else begin
            if (write_enable) begin
                case (awaddr_reg)
                    5'h00: rsa_plaintext <= wdata_reg;
                    5'h04: rsa_n <= wdata_reg;
                    5'h08: rsa_e <= wdata_reg;
                    5'h0C: rsa_d <= wdata_reg;
                    5'h1E: start_enc <= (wdata_reg == 32'h1) ? 1 : start_enc; // Persist start_enc
                    5'h1F: start_dec <= (wdata_reg == 32'h1) ? 1 : start_dec; // Persist start_dec
                endcase
                if (awaddr_reg <= 5'h0C) begin
                    mem_write[(awaddr_reg >> 2)] <= wdata_reg;
                end
            end
            // Clear start signals only when done
            if (done_enc) start_enc <= 0;
            if (done_dec) start_dec <= 0;

            if (done_enc) begin
                mem_result[0] <= rsa_ciphertext;
            end
            if (done_dec) begin
                mem_result[1] <= rsa_decrypted;
            end
        end
    end
endmodule
