// opcodes.v - Instruction definitions
`ifndef OPCODES_V
`define OPCODES_V

// Instruction Opcodes (6-bit)
`define OP_LDI   6'b000000  // Load Immediate to X/Y
`define OP_LDA   6'b000001  // Load from Address to X/Y
`define OP_STA   6'b000010  // Store X/Y to Address
`define OP_ADD   6'b000011  // Add
`define OP_SUB   6'b000100  // Subtract
`define OP_AND   6'b000101  // AND
`define OP_OR    6'b000110  // OR
`define OP_XOR   6'b000111  // XOR
`define OP_NOT   6'b001000  // NOT
`define OP_LSL   6'b001001  // Logical Shift Left
`define OP_LSR   6'b001010  // Logical Shift Right
`define OP_RSL   6'b001011  // Rotate Shift Left
`define OP_RSR   6'b001100  // Rotate Shift Right
`define OP_MOV   6'b001101  // Move
`define OP_MUL   6'b001110  // Multiply
`define OP_DIV   6'b001111  // Divide
`define OP_MOD   6'b010000  // Modulo
`define OP_CMP   6'b010001  // Compare
`define OP_TST   6'b010010  // Test
`define OP_INC   6'b010011  // Increment
`define OP_DEC   6'b010100  // Decrement

// Branch Instructions
`define OP_BRZ   6'b010101  // Branch if Zero
`define OP_BRN   6'b010110  // Branch if Negative
`define OP_BRC   6'b010111  // Branch if Carry
`define OP_BRO   6'b011000  // Branch if Overflow
`define OP_BRA   6'b011001  // Branch Always
`define OP_JMP   6'b011010  // Jump to subroutine
`define OP_RET   6'b011011  // Return from subroutine

// Register selection
`define REG_X    1'b0
`define REG_Y    1'b1

// Flag positions in flag register
`define FLAG_Z   3  // Zero flag
`define FLAG_N   2  // Negative flag  
`define FLAG_C   1  // Carry flag
`define FLAG_O   0  // Overflow flag

`endif