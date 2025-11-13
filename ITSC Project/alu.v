`include "opcodes.v"

module alu(
    input [15:0] a,
    input [15:0] b,
    input [5:0] opcode,
    output reg [15:0] result,
    output reg zero,
    output reg negative,
    output reg carry,
    output reg overflow
);
    
    reg [16:0] temp_result;
    reg [31:0] temp_mul;
    reg [15:0] crypto_temp;
    integer rotation_amount;
    
    always @(*) begin
        // Default values
        result = 16'b0;
        zero = 1'b0;
        negative = 1'b0;
        carry = 1'b0;
        overflow = 1'b0;
        temp_result = 17'b0;
        temp_mul = 32'b0;
        crypto_temp = 16'b0;
        rotation_amount = 0;
        
        case(opcode)
            `OP_ADD: begin
                temp_result = {1'b0, a} + {1'b0, b};
                result = temp_result[15:0];
                carry = temp_result[16];
                overflow = (a[15] == b[15]) && (result[15] != a[15]);
            end
            
            `OP_SUB: begin
                temp_result = {1'b0, a} - {1'b0, b};
                result = temp_result[15:0];
                carry = temp_result[16];
                overflow = (a[15] != b[15]) && (result[15] != a[15]);
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
            
            `OP_MOV: begin
                result = b;
            end
            
            // Cryptographic Operations
            `OP_AES_ENC: begin
                result = {a[7:0] ^ b[15:8], a[15:8] ^ b[7:0]};
                result = result ^ 16'hA5A5;
            end
            
            `OP_AES_DEC: begin
                result = {a[7:0] ^ b[15:8], a[15:8] ^ b[7:0]};
                result = result ^ 16'h5A5A;
            end
            
            `OP_SHA256_H: begin
                crypto_temp = (a & b) ^ ((~a) & {b[7:0], b[15:8]});
                result = crypto_temp + 16'h5A82;
            end
            
            `OP_SHA256_K: begin
                result = (a + b) ^ 16'h6A09 ^ {b[7:0], b[15:8]};
            end
            
            `OP_MOD_ADD: begin
                temp_result = {1'b0, a} + {1'b0, b};
                result = temp_result[15:0];
                carry = temp_result[16];
            end
            
            `OP_MOD_MUL: begin
                temp_mul = a * b;
                result = temp_mul[15:0];
                carry = |temp_mul[31:16];
                overflow = |temp_mul[31:16];
            end
            
            `OP_ROT_R: begin
                rotation_amount = b[3:0];
                result = (a >> rotation_amount) | (a << (16 - rotation_amount));
                carry = a[rotation_amount-1];
            end
            
            `OP_XOR3: begin
                result = a ^ {b[15:8], b[7:0]} ^ {b[7:0], b[15:8]};
            end
            
            default: begin
                result = a;
            end
        endcase
        
        // Set zero and negative flags
        if (opcode != `OP_CMP) begin
            zero = (result == 16'b0);
            negative = result[15];
        end
    end
    
endmodule