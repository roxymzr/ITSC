module memory(
    input clk,
    input [15:0] address,
    input [15:0] data_in,
    input write_en,
    input read_en,
    output reg [15:0] data_out
);

    reg [15:0] mem [0:31];
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            mem[i] = 16'b0;
        end
        
        mem[0] = {`OP_LDI, `REG_X, 9'h0AA};  // LDI X, 0xAA
        mem[1] = {`OP_LDI, `REG_Y, 9'h055};  // LDI Y, 0x55
        mem[2] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X
        mem[3] = {`OP_AES_ENC, `REG_X, 9'h000}; // AES_ENC A, X
        
        mem[4] = {`OP_LDI, `REG_X, 9'h012};  // LDI X, 0x12
        mem[5] = {`OP_LDI, `REG_Y, 9'h034};  // LDI Y, 0x34
        mem[6] = {`OP_SHA256_H, `REG_X, 9'h000}; // SHA256_H A, X
        mem[7] = {`OP_SHA256_H, `REG_Y, 9'h000}; // SHA256_H A, Y
        
        mem[8] = {`OP_LDI, `REG_X, 9'h0FF};  // LDI X, 0xFF
        mem[9] = {`OP_LDI, `REG_Y, 9'h001};  // LDI Y, 0x01
        mem[10] = {`OP_MOD_ADD, `REG_X, 9'h000}; // MOD_ADD A, X
        mem[11] = {`OP_MOD_MUL, `REG_Y, 9'h000}; // MOD_MUL A, Y
        
        mem[12] = {`OP_LDI, `REG_X, 9'h00F};  // LDI X, 0x0F
        mem[13] = {`OP_LDI, `REG_Y, 9'h004};  // LDI Y, 0x04
        mem[14] = {`OP_ROT_R, `REG_X, 9'h000}; // ROT_R A, X
        
        mem[15] = {`OP_LDI, `REG_X, 9'h0FF};  // LDI X, 0xFF
        mem[16] = {`OP_LDI, `REG_Y, 9'h0AA};  // LDI Y, 0xAA
        mem[17] = {`OP_XOR3, `REG_X, 9'h000};  // XOR3 A, X
        
        mem[18] = {`OP_BRA, 10'h012};          // BRA 18 (loop)
        
        data_out = 16'b0;
    end

    always @(posedge clk) begin
        if (write_en && address < 32) begin
            mem[address] <= data_in;
        end
    end

    always @(*) begin
        if (read_en && address < 32) begin
            data_out = mem[address];
        end else begin
            data_out = 16'b0;
        end
    end

endmodule