`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 11:00:31 AM
// Design Name: 
// Module Name: rsa_top
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



module rsa_top(
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
    output [31:0] rdata,
    output [1:0] rresp,
    output rvalid,
    input rready,

    output [31:0] out_plaintext,
    output [31:0] out_ciphertext,
    output [31:0] out_decrypted
);

    wire [31:0] plaintext, n, e, d;
    wire start_enc, start_dec;
    wire [31:0] ciphertext, decrypted;
    wire done_enc, done_dec;

    assign out_plaintext = plaintext;
    assign out_ciphertext = ciphertext;
    assign out_decrypted = decrypted;

    rsa_axi_slave slave(
        .clk(clk), .rst(rst),
        .awaddr(awaddr), .awvalid(awvalid), .awready(awready),
        .wdata(wdata), .wstrb(wstrb), .wvalid(wvalid), .wready(wready),
        .bresp(bresp), .bvalid(bvalid), .bready(bready),
        .araddr(araddr), .arvalid(arvalid), .arready(arready),
        .rdata(rdata), .rresp(rresp), .rvalid(rvalid), .rready(rready),
        .rsa_plaintext(plaintext),
        .rsa_n(n),
        .rsa_e(e),
        .rsa_d(d),
        .start_enc(start_enc),
        .start_dec(start_dec),
        .rsa_ciphertext(ciphertext),
        .rsa_decrypted(decrypted),
        .done_enc(done_enc),
        .done_dec(done_dec)
    );

    rsa_encrypt enc(
        .clk(clk), .rst(rst),
        .plaintext(plaintext),
        .n(n),
        .e(e),
        .start(start_enc),
        .ciphertext(ciphertext),
        .done(done_enc)
    );

    rsa_decrypt dec(
        .clk(clk), .rst(rst),
        .ciphertext(ciphertext),
        .n(n),
        .d(d),
        .start(start_dec),
        .plaintext(decrypted),
        .done(done_dec)
    );

endmodule