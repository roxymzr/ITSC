`timescale 1ns/1ps
`include "opcodes.v"

module control_unit_tb;
    reg [15:0] instruction;
    reg [3:0] flags;
    wire [5:0] alu_op;
    wire reg_write_en;
    wire [2:0] reg_sel;
    wire flag_write_en;
    wire mem_read, mem_write;
    wire [1:0] pc_sel;
    wire [15:0] immediate;
    wire use_immediate;
    
    control_unit uut(
        .instruction(instruction),
        .flags(flags),
        .alu_op(alu_op),
        .reg_write_en(reg_write_en),
        .reg_sel(reg_sel),
        .flag_write_en(flag_write_en),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .pc_sel(pc_sel),
        .immediate(immediate),
        .use_immediate(use_immediate)
    );
    
    initial begin
        $display("=== FIXED CONTROL UNIT TEST ===");
        $display("Time\tInstr\tOp\tRegW\tReg\tFlagW\tUseImm\tImmediate");
        $monitor("%0t\t%h\t%h\t%b\t%h\t%b\t%b\t%h", 
                 $time, instruction, alu_op, reg_write_en, reg_sel,
                 flag_write_en, use_immediate, immediate);
        
        // Test ADD with register 
        #10;
        instruction = {`OP_ADD, `REG_X, 9'h000};
        flags = 4'b0000;
        
        // Test ADD with immediate 
        #10;
        instruction = {`OP_ADD, `REG_X, 9'h789};
        
        // Test INC 
        #10;
        instruction = {`OP_INC, 1'b0, 9'h123}; 
        
        // Test DEC   
        #10;
        instruction = {`OP_DEC, 1'b0, 9'h456}; 
        
        // Test CMP with register
        #10;
        instruction = {`OP_CMP, `REG_Y, 9'h000};
        
        // Test CMP with immediate
        #10;
        instruction = {`OP_CMP, `REG_Y, 9'h123};
        
        #10;
        $display("=== TEST COMPLETE ===");
        $stop;
    end
endmodule