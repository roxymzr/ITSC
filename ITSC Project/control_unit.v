`include "opcodes.v"

module control_unit(
    input [15:0] instruction,
    input [3:0] flags,
    output reg [5:0] alu_op,
    output reg reg_write_en,
    output reg [2:0] reg_sel,
    output reg flag_write_en,
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] pc_sel,
    output reg [15:0] immediate,
    output reg use_immediate
);

    wire [5:0] opcode = instruction[15:10];
    wire reg_bit = instruction[9];
    wire [8:0] imm9 = instruction[8:0];
    wire [9:0] branch_addr = instruction[9:0];

    localparam PC_INC = 2'b00;
    localparam PC_BRANCH = 2'b01;
    localparam PC_JUMP = 2'b10;
    localparam PC_RETURN = 2'b11;

    localparam REG_A  = 3'b000;
    localparam REG_X  = 3'b001;
    localparam REG_Y  = 3'b010;
    localparam REG_SP = 3'b011;
    localparam REG_PC = 3'b100;

    always @(*) begin
        // Default values
        alu_op = `OP_ADD;
        reg_write_en = 1'b0;
        reg_sel = REG_A;
        flag_write_en = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        pc_sel = PC_INC;
        use_immediate = 1'b0;
        
        // Sign-extend 9-bit immediate to 16-bit
        immediate = { {7{imm9[8]}}, imm9 };
        
        case(opcode)
            `OP_LDI: begin
                alu_op = `OP_MOV;
                reg_write_en = 1'b1;
                // reg_bit = 0 for X, 1 for Y
                reg_sel = (reg_bit == `REG_X) ? REG_X : REG_Y;
                use_immediate = 1'b1;
            end
            
            `OP_LDA: begin
                // Load from memory address to X/Y
                alu_op = `OP_MOV;
                reg_write_en = 1'b1;
                reg_sel = (reg_bit == `REG_X) ? REG_X : REG_Y;
                mem_read = 1'b1;
                use_immediate = 1'b1;  // Address is immediate
            end
            
            `OP_STA: begin
                // Store X/Y to memory address
                alu_op = `OP_MOV;
                mem_write = 1'b1;
                use_immediate = 1'b1;  // Address is immediate
            end
            
            // Arithmetic instructions
            `OP_ADD, `OP_SUB, `OP_MUL, `OP_DIV, `OP_MOD: begin
                alu_op = opcode;
                reg_write_en = 1'b1;
                reg_sel = REG_A;
                flag_write_en = 1'b1;
                use_immediate = 1'b0;
            end
            
            // Special arithmetic (no second operand)
            `OP_INC, `OP_DEC: begin
                alu_op = opcode;
                reg_write_en = 1'b1;
                reg_sel = REG_A;
                flag_write_en = 1'b1;
                use_immediate = 1'b0;
            end
            
            // Logic instructions
            `OP_AND, `OP_OR, `OP_XOR, `OP_NOT: begin
                alu_op = opcode;
                reg_write_en = 1'b1;
                reg_sel = REG_A;
                flag_write_en = 1'b1;
                use_immediate = 1'b0;
            end
            
            `OP_MOV: begin
                alu_op = opcode;
                reg_write_en = 1'b1;
                reg_sel = REG_A;
                flag_write_en = 1'b1;
                use_immediate = 1'b0;
            end
            
            // Shift/Rotate instructions
            `OP_LSL, `OP_LSR, `OP_RSL, `OP_RSR: begin
                alu_op = opcode;
                reg_write_en = 1'b1;
                reg_sel = REG_A;
                flag_write_en = 1'b1;
                use_immediate = 1'b0;
            end
            
            // Comparison instructions
            `OP_CMP, `OP_TST: begin
                alu_op = opcode;
                flag_write_en = 1'b1;
                use_immediate = 1'b0;
            end
            
            // Branch instructions
            `OP_BRA: begin
                pc_sel = PC_BRANCH;
                use_immediate = 1'b1;
                immediate = {6'b0, branch_addr};  // Zero-extend branch address
            end
            
            `OP_BRZ: begin
                if (flags[`FLAG_Z]) pc_sel = PC_BRANCH;
                else pc_sel = PC_INC;
                use_immediate = 1'b1;
                immediate = {6'b0, branch_addr};
            end
            
            `OP_BRN: begin
                if (flags[`FLAG_N]) pc_sel = PC_BRANCH;
                else pc_sel = PC_INC;
                use_immediate = 1'b1;
                immediate = {6'b0, branch_addr};
            end
            
            `OP_BRC: begin
                if (flags[`FLAG_C]) pc_sel = PC_BRANCH;
                else pc_sel = PC_INC;
                use_immediate = 1'b1;
                immediate = {6'b0, branch_addr};
            end
            
            `OP_BRO: begin
                if (flags[`FLAG_O]) pc_sel = PC_BRANCH;
                else pc_sel = PC_INC;
                use_immediate = 1'b1;
                immediate = {6'b0, branch_addr};
            end
            
            `OP_JMP: begin
                pc_sel = PC_JUMP;
                use_immediate = 1'b1;
                immediate = {6'b0, branch_addr};
            end
            
            `OP_RET: begin
                pc_sel = PC_RETURN;
            end
            
            // Cryptographic instructions (structural)
            `OP_AES_ENC, `OP_AES_DEC, `OP_SHA256_H, `OP_SHA256_K,
            `OP_MOD_ADD, `OP_MOD_MUL, `OP_ROT_R, `OP_XOR3: begin
                alu_op = opcode;
                reg_write_en = 1'b1;
                reg_sel = REG_A;
                flag_write_en = 1'b1;
                use_immediate = 1'b0;
            end
            
            default: begin
                reg_write_en = 1'b0;
                flag_write_en = 1'b0;
            end
        endcase
    end

endmodule