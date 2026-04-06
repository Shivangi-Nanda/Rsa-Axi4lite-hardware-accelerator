`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 11:21:00 PM
// Design Name: 
// Module Name: tb_rsa
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


module tb_rsa();  
    reg clk = 0, rst = 1;

    reg [4:0] awaddr = 0;
    reg awvalid = 0;
    wire awready;
    reg [31:0] wdata = 0;
    reg [3:0] wstrb = 4'hF;
    reg wvalid = 0;
    wire wready;
    wire [1:0] bresp;
    wire bvalid;
    reg bready = 1;

    reg [4:0] araddr = 0;
    reg arvalid = 0;
    wire arready;
    wire [31:0] rdata;
    wire [1:0] rresp;
    wire rvalid;
    reg rready = 1;

    wire [31:0] plaintext, ciphertext, decrypted;

    rsa_top dut (
        .clk(clk), .rst(rst),
        .awaddr(awaddr), .awvalid(awvalid), .awready(awready),
        .wdata(wdata), .wstrb(wstrb), .wvalid(wvalid), .wready(wready),
        .bresp(bresp), .bvalid(bvalid), .bready(bready),
        .araddr(araddr), .arvalid(arvalid), .arready(arready),
        .rdata(rdata), .rresp(rresp), .rvalid(rvalid), .rready(rready),
        .out_plaintext(plaintext),
        .out_ciphertext(ciphertext),
        .out_decrypted(decrypted)
    );

    always #5 clk = ~clk;

    task write(input [4:0] addr, input [31:0] data);
    begin
        @(posedge clk);
        awaddr <= addr; awvalid <= 1;
        wdata <= data; wvalid <= 1;
        @(posedge clk);
        awvalid <= 0; wvalid <= 0;
    end
    endtask

    task read(input [4:0] addr);
    begin
        @(posedge clk);
        araddr <= addr; arvalid <= 1;
        @(posedge clk);
        arvalid <= 0;
    end
    endtask

    initial begin
        $dumpfile("rsa_wave.vcd");
        $dumpvars(0, tb_rsa);
        $dumpvars(0, plaintext, ciphertext, decrypted);

        rst = 1;
        #20;
        rst = 0;

        // Write plaintext (123)
        write(5'h00, 32'h0000007B);
        read(5'h00); #10;

        // Write n (323)
        write(5'h04, 32'h00000143);
        read(5'h04); #10;

        // Write e (5)
        write(5'h08, 32'h00000005);
        read(5'h08); #10;

        // Write d (173)
        write(5'h0C, 32'h000000AD);
        read(5'h0C); #10;

        // Start encryption
        write(5'h1E, 32'h1);
        #100;  

        // Read ciphertext
        read(5'h10); #10;

        // Start decryption
        write(5'h1F, 32'h1);
        #200;  

        // Read decrypted
        read(5'h14); #10;

        // Display output
        $display("\n--- RSA AXI Simulation Output ---");
        $display("Plaintext   : %h", plaintext);
        $display("Ciphertext  : %h", ciphertext);
        $display("Decrypted   : %h", decrypted);
        $display("----------------------------------\n");

        #200;
        $finish;
    end
endmodule

