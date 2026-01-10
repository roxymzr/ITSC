`include "opcodes.v"

module pc_unit(
    input [15:0] current_pc,
    input [9:0] branch_addr,
    input [1:0] pc_sel,
    input [15:0] stack_data,
    output reg [15:0] next_pc
);

    always @(*) begin
        case(pc_sel)
            2'b00: next_pc = current_pc + 1;      // Normal increment
            2'b01: next_pc = {6'b0, branch_addr}; // Branch
            2'b10: next_pc = {6'b0, branch_addr}; // Jump
            2'b11: next_pc = stack_data;          // Return
            default: next_pc = current_pc + 1;
        endcase
    end

endmodule