`timescale 1ns/1ps
`include "opcodes.v"

module alu_tb;
    reg [15:0] a, b;
    reg [5:0] opcode;
    wire [15:0] result;
    wire zero, negative, carry, overflow;
    
    alu uut(
        .a(a),
        .b(b), 
        .opcode(opcode),
        .result(result),
        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow)
    );
    
    initial begin
        $display("=== COMPLETE ALU TEST BENCH ===");
        $display("Time\tOpcode\tA\tB\tResult\tZ\tN\tC\tO");
        $monitor("%0t\t%h\t%h\t%h\t%h\t%b\t%b\t%b\t%b", 
                 $time, opcode, a, b, result, zero, negative, carry, overflow);
        
        // Test ADD
        #10;
        a = 16'h0005; b = 16'h0003; opcode = `OP_ADD;
        
        // Test SUB  
        #10;
        a = 16'h0005; b = 16'h0003; opcode = `OP_SUB;
        
        // Test MUL
        #10;
        a = 16'h0004; b = 16'h0003; opcode = `OP_MUL;
        
        // Test DIV
        #10;
        a = 16'h000F; b = 16'h0003; opcode = `OP_DIV;
        
        // Test MOD
        #10;
        a = 16'h000F; b = 16'h0004; opcode = `OP_MOD;
        
        // Test AND
        #10;
        a = 16'h00FF; b = 16'h00F0; opcode = `OP_AND;
        
        // Test OR
        #10;
        a = 16'h000F; b = 16'h00F0; opcode = `OP_OR;
        
        // Test XOR
        #10;
        a = 16'h00FF; b = 16'h00F0; opcode = `OP_XOR;
        
        // Test NOT
        #10;
        a = 16'h00FF; b = 16'h0000; opcode = `OP_NOT;
        
        // Test LSL
        #10;
        a = 16'h0001; b = 16'h0000; opcode = `OP_LSL;
        
        // Test LSR
        #10;
        a = 16'h8000; b = 16'h0000; opcode = `OP_LSR;
        
        // Test RSL (Rotate Left)
        #10;
        a = 16'h8001; b = 16'h0000; opcode = `OP_RSL;
        
        // Test RSR (Rotate Right)
        #10;
        a = 16'h0001; b = 16'h0000; opcode = `OP_RSR;
        
        // Test CMP (equal)
        #10;
        a = 16'h0010; b = 16'h0010; opcode = `OP_CMP;
        
        // Test CMP (a > b)
        #10;
        a = 16'h0020; b = 16'h0010; opcode = `OP_CMP;
        
        // Test TST
        #10;
        a = 16'h00FF; b = 16'h000F; opcode = `OP_TST;
        
        // Test Division by Zero
        #10;
        a = 16'h0010; b = 16'h0000; opcode = `OP_DIV;
        
        #10;
        $display("=== ALL TESTS COMPLETE ===");
        $stop;
    end
endmodule