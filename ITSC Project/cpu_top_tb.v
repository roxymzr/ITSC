`timescale 1ns/1ps
`include "opcodes.v"

module cpu_top_tb;
    reg clk, rst;
    wire [15:0] pc_out, a_out, x_out, y_out;
    wire [3:0] flags_out;
    
    cpu_top uut(
        .clk(clk),
        .rst(rst),
        .pc_out(pc_out),
        .a_out(a_out),
        .x_out(x_out),
        .y_out(y_out),
        .flags_out(flags_out)
    );
    
    always #5 clk = ~clk;
    
    integer cycle_count = 0;
    
    function [8*20:1] decode_instruction;
        input [15:0] instr;
        reg [5:0] opcode;
        reg reg_bit;
        reg [8:0] imm9;
        reg [9:0] branch_addr;
        begin
            opcode = instr[15:10];
            reg_bit = instr[9];
            imm9 = instr[8:0];
            branch_addr = instr[9:0];
            
            case(opcode)
                `OP_LDI: decode_instruction = (reg_bit == `REG_X) ? 
                    $sformatf("LDI X, %0d", imm9) : 
                    $sformatf("LDI Y, %0d", imm9);
                `OP_MOV: decode_instruction = (reg_bit == `REG_X) ? 
                    "MOV A, X" : "MOV A, Y";
                `OP_ADD: decode_instruction = (reg_bit == `REG_X) ? 
                    "ADD X" : "ADD Y";
                `OP_BRA: decode_instruction = $sformatf("BRA %0d", branch_addr);
                default:  decode_instruction = "UNKNOWN";
            endcase
        end
    endfunction
    
    always @(posedge clk) begin
        if (!rst) begin
            cycle_count <= cycle_count + 1;
            $display("Cycle %0d: PC=%h -> %s", cycle_count, pc_out, 
                     decode_instruction(uut.instruction));
            $display("        A=%h, X=%h, Y=%h, Flags=%b", 
                     a_out, x_out, y_out, flags_out);
        end
    end
    
    initial begin
        $display("=== FINAL CPU TEST ===");
        
        clk = 0;
        rst = 1;
        
        repeat(3) @(posedge clk);
        rst = 0;
        $display("Reset released - starting execution");
        $display("-----------------------------------");
        
        repeat(8) @(posedge clk);
        
        $display("-----------------------------------");
        $display("=== FINAL RESULTS ===");
        $display("Executed %0d cycles", cycle_count);
        $display("PC=%h, A=%h, X=%h, Y=%h", pc_out, a_out, x_out, y_out);
        
        if (a_out == 8) 
            $display("SUCCESS: A = 8 (5 + 3)");
        else
            $display("FAILED: A = %h, expected 8", a_out);
            
        $stop;
    end
endmodule