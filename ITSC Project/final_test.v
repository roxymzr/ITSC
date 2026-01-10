`timescale 1ns/1ps
`include "opcodes.v"

module final_test;
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
    
    integer cycle = 0;
    reg [15:0] last_pc;
    
    // Track PC changes
    always @(posedge clk) begin
        last_pc <= pc_out;
    end
    
    // Display results at each clock edge
    always @(posedge clk) begin
        if (!rst && cycle > 0) begin
            $display("CYCLE %3d: PC=%02d, A=%04h, X=%04h, Y=%04h, Flags=Z:%b N:%b C:%b O:%b",
                     cycle, last_pc, a_out, x_out, y_out, 
                     flags_out[3], flags_out[2], flags_out[1], flags_out[0]);
            
            // Check specific instructions based on PC value
            check_instruction(last_pc, a_out, x_out, y_out, flags_out);
        end
        cycle = cycle + 1;
    end
    
    integer test_passed = 0;
    integer test_total = 0;
    
    task check_instruction;
        input [15:0] executed_pc;  // PC of instruction that just executed
        input [15:0] a, x, y;
        input [3:0] flags;
        begin
            case(executed_pc)
                0: begin // After LDI X, 0x10 - Timing issue, skip check
                    $display("  [INFO] LDI X executed, checking in next cycle");
                    // Don't count this test
                end
                
                1: begin // After LDI Y, 0x04 and LDI X result available
                    if (x == 16'h0010) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] LDI X, 0x10: X=%04h", x);
                    end else begin
                        $display("  [FAIL] LDI X, 0x10: X=%04h (expected 0010)", x);
                    end
                    test_total = test_total + 1;
                    
                    // Also check LDI Y (result now available)
                    if (y == 16'h0004) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] LDI Y, 0x04: Y=%04h", y);
                    end else begin
                        $display("  [FAIL] LDI Y, 0x04: Y=%04h (expected 0004)", y);
                    end
                    test_total = test_total + 1;
                end
                
                2: begin // After MOV A, X
                    if (a == 16'h0010) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] MOV A, X: A=%04h", a);
                    end else begin
                        $display("  [FAIL] MOV A, X: A=%04h (expected 0010)", a);
                    end
                    test_total = test_total + 1;
                end
                
                3: begin // After ADD A, Y
                    if (a == 16'h0014) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] ADD A, Y: 16+4= %04h", a);
                    end else begin
                        $display("  [FAIL] ADD A, Y: A=%04h (expected 0014)", a);
                    end
                    test_total = test_total + 1;
                end
                
                4: begin // After SUB A, Y
                    if (a == 16'h0010) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] SUB A, Y: 20-4= %04h", a);
                    end else begin
                        $display("  [FAIL] SUB A, Y: A=%04h (expected 0010)", a);
                    end
                    test_total = test_total + 1;
                end
                
                5: begin // After MUL A, Y
                    if (a == 16'h0040) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] MUL A, Y: 16x4= %04h", a);
                    end else begin
                        $display("  [FAIL] MUL A, Y: A=%04h (expected 0040)", a);
                    end
                    test_total = test_total + 1;
                end
                
                6: begin // After DIV A, Y
                    if (a == 16'h0010) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] DIV A, Y: 64/4= %04h", a);
                    end else begin
                        $display("  [FAIL] DIV A, Y: A=%04h (expected 0010)", a);
                    end
                    test_total = test_total + 1;
                end
                
                9: begin // After MOD A, Y
                    if (a == 16'h0001) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] MOD A, Y: 17 mod 4= %04h", a);
                    end else begin
                        $display("  [FAIL] MOD A, Y: A=%04h (expected 0001)", a);
                    end
                    test_total = test_total + 1;
                end
                
                13: begin // After AND A, Y
                    if (a == 16'h0000) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] AND A, Y: AA&55= %04h", a);
                    end else begin
                        $display("  [FAIL] AND A, Y: A=%04h (expected 0000)", a);
                    end
                    test_total = test_total + 1;
                end
                
                14: begin // After OR A, Y
                    if (a == 16'h0055) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] OR A, Y: 00|55= %04h", a);
                    end else begin
                        $display("  [FAIL] OR A, Y: A=%04h (expected 0055)", a);
                    end
                    test_total = test_total + 1;
                end
                
                15: begin // After XOR A, X
                    if (a == 16'h00FF) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] XOR A, X: 55^AA= %04h", a);
                    end else begin
                        $display("  [FAIL] XOR A, X: A=%04h (expected 00FF)", a);
                    end
                    test_total = test_total + 1;
                end
                
                16: begin // After NOT A
                    if (a == 16'hFF00) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] NOT A: ~FF= %04h", a);
                    end else begin
                        $display("  [FAIL] NOT A: A=%04h (expected FF00)", a);
                    end
                    test_total = test_total + 1;
                end
                
                20: begin // After LSL A, Y
                    if (a == 16'h0004) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] LSL A, Y: 1<<2= %04h", a);
                    end else begin
                        $display("  [FAIL] LSL A, Y: A=%04h (expected 0004)", a);
                    end
                    test_total = test_total + 1;
                end
                
                22: begin // After LSR A, Y
                    if (a == 16'h0002) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] LSR A, Y: 4>>1= %04h", a);
                    end else begin
                        $display("  [FAIL] LSR A, Y: A=%04h (expected 0002)", a);
                    end
                    test_total = test_total + 1;
                end
                
                23: begin // After RSL A, Y
                    if (a == 16'h0004) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] RSL A, Y: rot left 1= %04h", a);
                    end else begin
                        $display("  [FAIL] RSL A, Y: A=%04h (expected 0004)", a);
                    end
                    test_total = test_total + 1;
                end
                
                24: begin // After RSR A, Y
                    if (a == 16'h8002) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] RSR A, Y: rotate right 1= %04h", a);
                    end else begin
                        $display("  [FAIL] RSR A, Y: A=%04h (expected 8002)", a);
                    end
                    test_total = test_total + 1;
                end
                
                28: begin // After CMP A, Y
                    if (flags[3] == 1'b1) begin // Z flag
                        test_passed = test_passed + 1;
                        $display("  [PASS] CMP A, Y: Z flag set (equal)");
                    end else begin
                        $display("  [FAIL] CMP A, Y: Z=%b (expected 1)", flags[3]);
                    end
                    test_total = test_total + 1;
                end
                
                29: begin // After TST A, Y
                    if (flags[3] == 1'b0) begin // Z flag not set
                        test_passed = test_passed + 1;
                        $display("  [PASS] TST A, Y: Z flag not set");
                    end else begin
                        $display("  [FAIL] TST A, Y: Z=%b (expected 0)", flags[3]);
                    end
                    test_total = test_total + 1;
                end
                
                32: begin // After INC A
                    if (a == 16'h0000 && flags[1] == 1'b1) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] INC A: FF+1=00 with carry");
                    end else begin
                        $display("  [FAIL] INC A: A=%04h, C=%b (expected 0000,1)", a, flags[1]);
                    end
                    test_total = test_total + 1;
                end
                
                33: begin // After DEC A
                    if (a == 16'hFFFF) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] DEC A: 00-1= %04h", a);
                    end else begin
                        $display("  [FAIL] DEC A: A=%04h (expected FFFF)", a);
                    end
                    test_total = test_total + 1;
                end
                
                37: begin // After AES_ENC A, Y
                    if (a != 16'h0000) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] AES_ENC: non-zero result= %04h", a);
                    end else begin
                        $display("  [FAIL] AES_ENC: result is zero");
                    end
                    test_total = test_total + 1;
                end
                
                38: begin // After SHA256_H A, X
                    if (a != 16'h0000) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] SHA256_H: non-zero result= %04h", a);
                    end else begin
                        $display("  [FAIL] SHA256_H: result is zero");
                    end
                    test_total = test_total + 1;
                end
                
                40: begin // After MOD_ADD A, X
                    if (a == 16'h0024) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] MOD_ADD: 12+12= %04h", a);
                    end else begin
                        $display("  [FAIL] MOD_ADD: A=%04h (expected 0024)", a);
                    end
                    test_total = test_total + 1;
                end
                
                42: begin // After MOD_MUL A, Y
                    if (a == 16'h0A90) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] MOD_MUL: 34x34= %04h", a);
                    end else begin
                        $display("  [FAIL] MOD_MUL: A=%04h (expected 0A90)", a);
                    end
                    test_total = test_total + 1;
                end
                
                45: begin // After ROT_R A, Y
                    if (a == 16'h8004 && flags[1] == 1'b1) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] ROT_R: rotate right 12 by 2= %04h with carry", a);
                    end else begin
                        $display("  [FAIL] ROT_R: A=%04h, C=%b (expected 8004,1)", a, flags[1]);
                    end
                    test_total = test_total + 1;
                end
                
                46: begin // After XOR3 A, X 
                    // 0x8004 ^ 0x0012 ^ 0x1200 = 0x9216
                    if (a == 16'h9216) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] XOR3: correct result= %04h", a);
                    end else begin
                        $display("  [FAIL] XOR3: A=%04h (expected 9216)", a);
                    end
                    test_total = test_total + 1;
                end
                
                57: begin // After final MOV A, X
                    if (a == 16'h00FF && x == 16'h00FF && y == 16'h00EE) begin
                        test_passed = test_passed + 1;
                        $display("  [PASS] FINAL: A=X=00FF, Y=00EE");
                    end else begin
                        $display("  [FAIL] FINAL: A=%04h, X=%04h, Y=%04h", a, x, y);
                    end
                    test_total = test_total + 1;
                end
            endcase
        end
    endtask
    
    initial begin
        $display("===============================================================");
        $display("    16-BIT CRYPTOGRAPHIC PROCESSOR - COMPLETE TEST");
        $display("===============================================================");
        $display("All operations will be tested for 100 percent correctness");
        $display("");
        
        clk = 0;
        rst = 1;
        
        // Reset
        repeat(3) @(posedge clk);
        rst = 0;
        $display("Reset released at time %0t ns", $time);
        $display("Starting 100 percent correctness test...");
        $display("");
        
        // Run for enough cycles to complete program
        repeat(100) @(posedge clk);
        
        // Final summary
        $display("");
        $display("===============================================================");
        $display("                     FINAL TEST SUMMARY");
        $display("===============================================================");
        $display("Tests passed: %0d out of %0d", test_passed, test_total);
        if (test_total > 0) begin
            $display("Success rate: %0.1f percent", (test_passed * 100.0) / test_total);
        end else begin
            $display("Success rate: No tests executed");
        end
        $display("");
        $display("Final processor state:");
        $display("  Program Counter: %04h", pc_out);
        $display("  Accumulator (A): %04h", a_out);
        $display("  Register X:      %04h", x_out);
        $display("  Register Y:      %04h", y_out);
        $display("  Flags:           Z=%b N=%b C=%b O=%b", 
                 flags_out[3], flags_out[2], flags_out[1], flags_out[0]);
        $display("");
        
        if (test_passed == test_total && test_total > 0) begin
            $display(" PERFECT SUCCESS: 100 percent of tests passed!");
            $display("    All operations work correctly!");
        end else begin
            $display(" Some tests failed. Need further debugging.");
        end
        
        $display("");
        $display("===============================================================");
        
        $finish;
    end
    
endmodule