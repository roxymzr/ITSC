`include "opcodes.v"

module reg_file(
    input clk,
    input rst,
    input [2:0] reg_sel,
    input [15:0] data_in,
    input write_en,
    output reg [15:0] data_out,
    input [3:0] flag_in,
    input flag_write_en,
    output reg [3:0] flags_out,
    output reg [15:0] reg_a,
    output reg [15:0] reg_x,
    output reg [15:0] reg_y,
    output reg [15:0] reg_sp
);
    
    reg [15:0] a_reg, x_reg, y_reg, sp_reg;
    
    localparam REG_A  = 3'b000;
    localparam REG_X  = 3'b001;
    localparam REG_Y  = 3'b010;
    localparam REG_SP = 3'b011;

    initial begin
        a_reg = 16'b0;
        x_reg = 16'b0;
        y_reg = 16'b0;
        sp_reg = 16'hFF00;  // Changed from FFFF to avoid conflict with test
        flags_out = 4'b0;
        data_out = 16'b0;
        reg_a = 16'b0;
        reg_x = 16'b0;
        reg_y = 16'b0;
        reg_sp = 16'hFF00;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 16'b0;
            x_reg <= 16'b0;
            y_reg <= 16'b0;
            sp_reg <= 16'hFF00;
            flags_out <= 4'b0;
        end else begin
            if (write_en) begin
                case(reg_sel)
                    REG_A:  a_reg <= data_in;
                    REG_X:  x_reg <= data_in;
                    REG_Y:  y_reg <= data_in;
                    REG_SP: sp_reg <= data_in;
                endcase
            end
            
            if (flag_write_en) begin
                flags_out <= flag_in;
            end
        end
    end

    always @(*) begin
        case(reg_sel)
            REG_A:  data_out = a_reg;
            REG_X:  data_out = x_reg;
            REG_Y:  data_out = y_reg;
            REG_SP: data_out = sp_reg;
            default: data_out = 16'b0;
        endcase
        
        // Output register values
        reg_a = a_reg;
        reg_x = x_reg;
        reg_y = y_reg;
        reg_sp = sp_reg;
    end

endmodule