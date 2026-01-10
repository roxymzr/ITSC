`include "opcodes.v"

module memory(
    input clk,
    input [15:0] address,
    input [15:0] data_in,
    input write_en,
    input read_en,
    output reg [15:0] data_out
);

    reg [15:0] mem [0:1023];  // 1KB memory
    
    integer i;
    initial begin
        // Initialize memory
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 16'b0;
        end
        
        // ============================================
        // PROGRAM DE TEST COMPREHENSIV
        // ============================================
        
        $display("[MEMORY] Initializing test program...");
        
        // Start from address 0
        mem[0] = {`OP_LDI, `REG_X, 9'h010};  // LDI X, 0x10 (16)
        mem[1] = {`OP_LDI, `REG_Y, 9'h004};  // LDI Y, 0x04 (4)
        
        mem[2] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X (A = 16)
        mem[3] = {`OP_ADD, `REG_Y, 9'h000};  // ADD A, Y (A = 20)
        
        mem[4] = {`OP_SUB, `REG_Y, 9'h000};  // SUB A, Y (A = 16)
        
        mem[5] = {`OP_MUL, `REG_Y, 9'h000};  // MUL A, Y (A = 64)
        
        mem[6] = {`OP_DIV, `REG_Y, 9'h000};  // DIV A, Y (A = 16)
        
        mem[7] = {`OP_LDI, `REG_X, 9'h011};  // LDI X, 0x11 (17)
        mem[8] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X (A = 17)
        mem[9] = {`OP_MOD, `REG_Y, 9'h000};  // MOD A, Y (A = 1)
        
        mem[10] = {`OP_LDI, `REG_X, 9'h0AA};  // LDI X, 0xAA (10101010)
        mem[11] = {`OP_LDI, `REG_Y, 9'h055};  // LDI Y, 0x55 (01010101)
        
        mem[12] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X
        mem[13] = {`OP_AND, `REG_Y, 9'h000};  // AND A, Y (A = 0x00)
        
        mem[14] = {`OP_OR, `REG_Y, 9'h000};   // OR A, Y (A = 0x55)
        
        mem[15] = {`OP_XOR, `REG_X, 9'h000};  // XOR A, X (A = 0xFF)
        
        mem[16] = {`OP_NOT, 1'b0, 9'h000};    // NOT A (A = 0xFF00)
        
        mem[17] = {`OP_LDI, `REG_X, 9'h001};  // LDI X, 0x01
        mem[18] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X (A = 0x0001)
        
        mem[19] = {`OP_LDI, `REG_Y, 9'h002};  // LDI Y, 0x02
        mem[20] = {`OP_LSL, `REG_Y, 9'h000};  // LSL A, Y (A = 0x0004)
        
        mem[21] = {`OP_LDI, `REG_Y, 9'h001};  // LDI Y, 0x01
        mem[22] = {`OP_LSR, `REG_Y, 9'h000};  // LSR A, Y (A = 0x0002)
        
        mem[23] = {`OP_RSL, `REG_Y, 9'h000};  // RSL A, Y (A = rotate left 0x0002 by 1 = 0x0004)
        
        mem[24] = {`OP_RSR, `REG_Y, 9'h000};  // RSR A, Y (A = rotate right 0x0004 by 1 = 0x8002)
        
        mem[25] = {`OP_LDI, `REG_X, 9'h010};  // LDI X, 0x10
        mem[26] = {`OP_LDI, `REG_Y, 9'h010};  // LDI Y, 0x10
        
        mem[27] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X
        mem[28] = {`OP_CMP, `REG_Y, 9'h000};  // CMP A, Y
        
        mem[29] = {`OP_TST, `REG_Y, 9'h000};  // TST A, Y
        
        mem[30] = {`OP_LDI, `REG_X, 9'h0FF};  // LDI X, 0xFF
        mem[31] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X (A = 0x00FF)
        
        mem[32] = {`OP_INC, 1'b0, 9'h000};    // INC A (A = 0x0100)
        
        mem[33] = {`OP_DEC, 1'b0, 9'h000};    // DEC A (A = 0x00FF)
        
        mem[34] = {`OP_LDI, `REG_X, 9'h012};  // LDI X, 0x12
        mem[35] = {`OP_LDI, `REG_Y, 9'h034};  // LDI Y, 0x34
        
        mem[36] = {`OP_MOV, `REG_X, 9'h000};      // MOV A, X
        mem[37] = {`OP_AES_ENC, `REG_Y, 9'h000};  // AES_ENC A, Y
        
        mem[38] = {`OP_SHA256_H, `REG_X, 9'h000}; // SHA256_H A, X
        
        mem[39] = {`OP_MOV, `REG_X, 9'h000};      // MOV A, X
        mem[40] = {`OP_MOD_ADD, `REG_X, 9'h000};  // MOD_ADD A, X
        
        mem[41] = {`OP_MOV, `REG_Y, 9'h000};      // MOV A, Y
        mem[42] = {`OP_MOD_MUL, `REG_Y, 9'h000};  // MOD_MUL A, Y
        
        mem[43] = {`OP_MOV, `REG_X, 9'h000};      // MOV A, X
        mem[44] = {`OP_LDI, `REG_Y, 9'h002};      // LDI Y, 0x02
        mem[45] = {`OP_ROT_R, `REG_Y, 9'h000};    // ROT_R A, Y
        
        mem[46] = {`OP_XOR3, `REG_X, 9'h000};     // XOR3 A, X
        
        mem[47] = {`OP_LDI, `REG_X, 9'h000};  // LDI X, 0x00 (set zero)
        mem[48] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X (A = 0)
        
        mem[49] = {`OP_BRZ, 10'h033};         // BRZ 51 decimal (0x33)
        
        mem[50] = {`OP_INC, 1'b0, 9'h000};    // INC A (skipped if branch taken)
        
        mem[51] = {`OP_LDI, `REG_X, 9'h001};  // LDI X, 0x01
        mem[52] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X
        
        mem[53] = {`OP_BRN, 10'h037};         // BRN 55 decimal (0x37)
        
        mem[54] = {`OP_INC, 1'b0, 9'h000};    // INC A (should execute)
        
        mem[55] = {`OP_LDI, `REG_X, 9'h0FF};  // LDI X, 0xFF (final value)
        mem[56] = {`OP_LDI, `REG_Y, 9'h0EE};  // LDI Y, 0xEE (final value)
        mem[57] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X (A = 0xFF)
        
        mem[58] = {`OP_BRA, 10'h03A};         // BRA 58 (infinite loop)
        
        $display("[MEMORY] Test program loaded successfully");
        $display("[MEMORY] Total instructions: 59");
    end

    always @(posedge clk) begin
        if (write_en && address < 1024) begin
            mem[address] <= data_in;
            $display("[MEMORY] Write: address=%04h, data=%04h", address, data_in);
        end
    end

    always @(*) begin
        if (address < 1024) begin
            data_out = mem[address];
        end else begin
            data_out = 16'b0;
        end
    end

endmodule