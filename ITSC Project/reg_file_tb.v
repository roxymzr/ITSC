`timescale 1ns/1ps
`include "opcodes.v"

module reg_file_tb;
    reg clk, rst;
    reg [2:0] reg_sel;
    reg [15:0] data_in;
    reg write_en;
    wire [15:0] data_out;
    reg [3:0] flag_in;
    reg flag_write_en;
    wire [3:0] flags_out;
    wire [15:0] reg_a, reg_x, reg_y, reg_sp, reg_pc;
    
    reg_file uut(
        .clk(clk),
        .rst(rst),
        .reg_sel(reg_sel),
        .data_in(data_in),
        .write_en(write_en),
        .data_out(data_out),
        .flag_in(flag_in),
        .flag_write_en(flag_write_en),
        .flags_out(flags_out),
        .reg_a(reg_a),
        .reg_x(reg_x),
        .reg_y(reg_y),
        .reg_sp(reg_sp),
        .reg_pc(reg_pc)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        $display("=== REGISTER FILE TEST BENCH ===");
        $display("Time\tReg\tWrite\tDataIn\tDataOut\tA\tX\tY\tSP\tPC\tFlags");
        $monitor("%0t\t%h\t%b\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%b", 
                 $time, reg_sel, write_en, data_in, data_out, 
                 reg_a, reg_x, reg_y, reg_sp, reg_pc, flags_out);
        
        clk = 0;
        rst = 1;
        write_en = 0;
        flag_write_en = 0;
        #20;
        rst = 0;
        
        #10;
        reg_sel = 3'b000; // A
        data_in = 16'h1234;
        write_en = 1;
        
        #10;
        reg_sel = 3'b001; // X
        data_in = 16'h5678;
        
        #10;
        reg_sel = 3'b010; // Y
        data_in = 16'h9ABC;
        
        #10;
        reg_sel = 3'b011; // SP
        data_in = 16'hF000;
        
        #10;
        reg_sel = 3'b100; // PC
        data_in = 16'h1000;
        
        #10;
        write_en = 0;
        
        #10;
        reg_sel = 3'b000; // Read A
        
        #10;
        reg_sel = 3'b001; // Read X
        
        #10;
        reg_sel = 3'b010; // Read Y
        
        #10;
        flag_in = 4'b1010; // Z=1, N=0, C=1, O=0
        flag_write_en = 1;
        
        #10;
        flag_write_en = 0;
        
        #10;
        $display("=== TEST COMPLETE ===");
        $stop;
    end
endmodule