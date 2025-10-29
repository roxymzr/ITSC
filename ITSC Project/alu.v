// alu.v - COMPLETE Arithmetic Logic Unit
`include "opcodes.v"

module alu(
    input [15:0] a,           // First operand (usually Accumulator)
    input [15:0] b,           // Second operand (from register or immediate)
    input [5:0] opcode,       // Operation to perform
    output reg [15:0] result, // ALU result
    output reg zero,          // Zero flag
    output reg negative,      // Negative flag  
    output reg carry,         // Carry flag
    output reg overflow       // Overflow flag
);
    
    // Temporary 17-bit for carry detection
    reg [16:0] temp_result;
    reg [31:0] temp_mul;      // 32-bit for multiplication
    
    always @(*) begin
        // Default values
        result = 16'b0;
        zero = 1'b0;
        negative = 1'b0;
        carry = 1'b0;
        overflow = 1'b0;
        temp_result = 17'b0;
        temp_mul = 32'b0;
        
        case(opcode)
            `OP_ADD: begin
                temp_result = {1'b0, a} + {1'b0, b};
                result = temp_result[15:0];
                carry = temp_result[16];
                // Overflow: when adding two positives gives negative, or two negatives gives positive
                overflow = (a[15] == b[15]) && (result[15] != a[15]);
            end
            
            `OP_SUB: begin
                temp_result = {1'b0, a} - {1'b0, b};
                result = temp_result[15:0];
                carry = temp_result[16]; // Actually borrow in subtraction
                // Overflow: when subtracting different signs gives wrong sign
                overflow = (a[15] != b[15]) && (result[15] != a[15]);
            end
            
            `OP_MUL: begin
                temp_mul = a * b;
                result = temp_mul[15:0];  // Lower 16 bits
                carry = |temp_mul[31:16]; // Carry if upper 16 bits are non-zero
                // For multiplication, overflow when result doesn't fit in 16 bits
                overflow = |temp_mul[31:16];
            end
            
            `OP_DIV: begin
                if (b != 16'b0) begin
                    result = a / b;
                    // Division doesn't typically set carry/overflow
                    carry = 1'b0;
                    overflow = 1'b0;
                end else begin
                    result = 16'hFFFF; // Division by zero - return max value
                    carry = 1'b1;      // Set carry to indicate error
                    overflow = 1'b1;
                end
            end
            
            `OP_MOD: begin
                if (b != 16'b0) begin
                    result = a % b;
                    carry = 1'b0;
                    overflow = 1'b0;
                end else begin
                    result = 16'hFFFF; // Mod by zero
                    carry = 1'b1;
                    overflow = 1'b1;
                end
            end
            
            `OP_AND: begin
                result = a & b;
            end
            
            `OP_OR: begin
                result = a | b;
            end
            
            `OP_XOR: begin
                result = a ^ b;
            end
            
            `OP_NOT: begin
                result = ~a;
            end
            
            `OP_LSL: begin
                {carry, result} = {a, 1'b0}; // Shift left, MSB goes to carry
            end
            
            `OP_LSR: begin
                {result, carry} = {1'b0, a}; // Shift right, LSB goes to carry
            end
            
            `OP_RSL: begin
                // Rotate left through carry (circular shift)
                result = {a[14:0], a[15]};
                carry = a[15]; // The bit that wrapped around
            end
            
            `OP_RSR: begin
                // Rotate right through carry (circular shift)  
                result = {a[0], a[15:1]};
                carry = a[0]; // The bit that wrapped around
            end
            
            `OP_MOV: begin
                result = b; // Move value from b to result
            end
            
            `OP_INC: begin
                result = a + 1;
                // Check for overflow when incrementing from 0xFFFF
                overflow = (a == 16'hFFFF);
            end
            
            `OP_DEC: begin
                result = a - 1;
                // Check for underflow when decrementing from 0x0000
                overflow = (a == 16'h0000);
            end
            
            `OP_CMP: begin
                // Compare is like SUB but only sets flags, doesn't store result
                temp_result = {1'b0, a} - {1'b0, b};
                result = a; // Keep original value
                carry = temp_result[16];
                overflow = (a[15] != b[15]) && (temp_result[15] != a[15]);
                // Set zero flag if equal
                zero = (temp_result[15:0] == 16'b0);
                negative = temp_result[15];
            end
            
            `OP_TST: begin
                // Test is like AND but only sets flags
                result = a & b;
                // Flags are set based on the result below
            end
            
            default: begin
                result = a; // Default: pass through A
            end
        endcase
        
        // Set zero and negative flags for most operations (except CMP which sets them above)
        if (opcode != `OP_CMP) begin
            zero = (result == 16'b0);
            negative = result[15];
        end
        
        // Special case: TST should not modify the result, only flags
        if (opcode == `OP_TST) begin
            result = a; // Restore original value for TST
        end
    end
    
endmodule