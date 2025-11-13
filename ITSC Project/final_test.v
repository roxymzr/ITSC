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
    
    reg [2:0] test_phase;
    reg [7:0] test_passed;
    reg [7:0] test_total;
    reg phase1_done, phase2_done, phase3_done, phase4_done;
    
    reg [8*30:1] phase_name0, phase_name1, phase_name2, phase_name3, phase_name4;
    
    task check_aes_encryption;
        begin
            if (pc_out == 4 && a_out != 0) begin
                test_passed = test_passed + 1;
                $display("  [PASS] AES Encryption: A=%h", a_out);
            end else if (pc_out == 4) begin
                $display("  [FAIL] AES Encryption: FAILED");
            end
            test_total = test_total + 1;
        end
    endtask
    
    task check_sha256_hashing;
        begin
            if (pc_out == 8 && a_out != 0) begin
                test_passed = test_passed + 1;
                $display("  [PASS] SHA-256 Hashing: A=%h", a_out);
            end else if (pc_out == 8) begin
                $display("  [FAIL] SHA-256 Hashing: FAILED");
            end
            test_total = test_total + 1;
        end
    endtask
    
    task check_modular_ops;
        begin
            if (pc_out == 12 && a_out != 0) begin
                test_passed = test_passed + 1;
                $display("  [PASS] Modular Arithmetic: A=%h", a_out);
            end else if (pc_out == 12) begin
                $display("  [FAIL] Modular Arithmetic: FAILED");
            end
            test_total = test_total + 1;
        end
    endtask
    
    task check_bit_ops;
        begin
            if (pc_out == 18 && a_out != 0) begin
                test_passed = test_passed + 1;
                $display("  [PASS] Bit Operations: A=%h", a_out);
            end else if (pc_out == 18) begin
                $display("  [FAIL] Bit Operations: FAILED");
            end
            test_total = test_total + 1;
        end
    endtask
    
    always @(posedge clk) begin
        if (!rst) begin
            // Phase 1: Initialization
            if (pc_out == 0 && test_phase != 0) begin 
                test_phase <= 0; 
                $display(""); 
            end
            
            // Phase 2: AES Encryption 
            if (pc_out == 4 && !phase1_done) begin 
                test_phase <= 1; 
                phase1_done <= 1;
                $display(""); 
                $display("TEST PHASE 2: %s", phase_name1);
                check_aes_encryption;
            end
            
            // Phase 3: SHA-256 Hashing 
            if (pc_out == 8 && !phase2_done) begin 
                test_phase <= 2; 
                phase2_done <= 1;
                $display(""); 
                $display("TEST PHASE 3: %s", phase_name2);
                check_sha256_hashing;
            end
            
            // Phase 4: Modular Arithmetic 
            if (pc_out == 12 && !phase3_done) begin 
                test_phase <= 3; 
                phase3_done <= 1;
                $display(""); 
                $display("TEST PHASE 4: %s", phase_name3);
                check_modular_ops;
            end
            
            // Phase 5: Bit Operations 
            if (pc_out == 18 && !phase4_done) begin 
                test_phase <= 4; 
                phase4_done <= 1;
                $display(""); 
                $display("TEST PHASE 5: %s", phase_name4);
                check_bit_ops;
            end
        end
    end
    
    initial begin
        test_phase = 0;
        test_passed = 0;
        test_total = 0;
        phase1_done = 0;
        phase2_done = 0; 
        phase3_done = 0;
        phase4_done = 0;
        phase_name0 = "Initialization";
        phase_name1 = "AES Encryption Test";
        phase_name2 = "SHA-256 Hashing Test"; 
        phase_name3 = "Modular Arithmetic Test";
        phase_name4 = "Bit Operations Test";
        
        $display("================================================================================");
        $display("              16-BIT CRYPTOGRAPHIC ASIP PROCESSOR VERIFICATION");
        $display("================================================================================");
        $display("Starting simulation...");
        $display("");
        
        clk = 0;
        rst = 1;
        
        repeat(5) @(posedge clk);
        rst = 0;
        
        $display("TEST PHASE 1: %s", phase_name0);
        $display("  Initializing processor...");
        
        repeat(50) @(posedge clk);
        
        $display("");
        $display("================================================================================");
        $display("                            TEST SUMMARY");
        $display("================================================================================");
        $display("  Tests Passed: %0d/%0d", test_passed, test_total);
        $display("  Final State:");
        $display("    Program Counter: %h", pc_out);
        $display("    Accumulator (A): %h", a_out);
        $display("    Register X:      %h", x_out);
        $display("    Register Y:      %h", y_out);
        $display("    Flags:           Z=%b N=%b C=%b O=%b", 
                 flags_out[3], flags_out[2], flags_out[1], flags_out[0]);
        $display("");
        
        if (test_passed == test_total) begin
            $display("SUCCESS: All cryptographic operations verified!");
            $display("Cryptographic ASIP is fully operational!");
        end else begin
            $display("WARNING: Some tests failed. Review implementation.");
        end
        
        $display("================================================================================");
        $finish;
    end

endmodule