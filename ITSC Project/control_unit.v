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
        
        immediate = { {7{imm9[8]}}, imm9 };
        
        case(opcode)
            `OP_LDI: begin
                reg_write_en = 1'b1;
                reg_sel = (reg_bit == `REG_X) ? REG_X : REG_Y;
                use_immediate = 1'b1;
            end
            
            `OP_MOV: begin
                alu_op = `OP_MOV;
                reg_write_en = 1'b1;
                reg_sel = REG_A;
                use_immediate = 1'b0;
            end
            
            `OP_ADD: begin
                alu_op = `OP_ADD;
                reg_write_en = 1'b1;
                reg_sel = REG_A;
                flag_write_en = 1'b1;
                use_immediate = 1'b0;
            end
            
            `OP_BRA: begin
                pc_sel = PC_BRANCH;
            end
            
            default: begin
                reg_write_en = 1'b0;
                flag_write_en = 1'b0;
            end
        endcase
    end

endmodule