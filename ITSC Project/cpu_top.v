`include "opcodes.v"

module cpu_top(
    input clk,
    input rst,
    output [15:0] pc_out,
    output [15:0] a_out,
    output [15:0] x_out,
    output [15:0] y_out,
    output [3:0] flags_out
);

    wire [15:0] instruction;
    wire [15:0] alu_result;
    wire [15:0] reg_data_out;
    wire [15:0] mem_data_out;
    wire [15:0] immediate;
    wire [5:0] alu_op;
    wire reg_write_en;
    wire [2:0] reg_sel;
    wire flag_write_en;
    wire mem_read;
    wire mem_write;
    wire [1:0] pc_sel;
    wire use_immediate;
    
    wire [15:0] alu_a, alu_b;
    wire [3:0] alu_flags;
    wire [15:0] current_pc;
    wire [15:0] next_pc;
    wire [15:0] sp;

    reg [15:0] pc_reg;
    
    // Extract opcode from instruction
    wire [5:0] instr_opcode = instruction[15:10];
    
    initial begin
        pc_reg = 16'b0;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_reg <= 16'b0;
        end else begin
            pc_reg <= next_pc;
        end
    end
    
    assign current_pc = pc_reg;
    assign pc_out = pc_reg;

    control_unit control(
        .instruction(instruction),
        .flags(flags_out),
        .alu_op(alu_op),
        .reg_write_en(reg_write_en),
        .reg_sel(reg_sel),
        .flag_write_en(flag_write_en),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .pc_sel(pc_sel),
        .immediate(immediate),
        .use_immediate(use_immediate)
    );

    alu alu_unit(
        .a(alu_a),
        .b(alu_b),
        .opcode(alu_op),
        .result(alu_result),
        .zero(alu_flags[3]),
        .negative(alu_flags[2]),
        .carry(alu_flags[1]),
        .overflow(alu_flags[0])
    );

    reg_file registers(
        .clk(clk),
        .rst(rst),
        .reg_sel(reg_sel),
        .data_in(alu_result),
        .write_en(reg_write_en),
        .data_out(reg_data_out),
        .flag_in(alu_flags),
        .flag_write_en(flag_write_en),
        .flags_out(flags_out),
        .reg_a(a_out),
        .reg_x(x_out),
        .reg_y(y_out),
        .reg_sp(sp)
    );

    memory mem(
        .clk(clk),
        .address(mem_write || mem_read ? alu_result : current_pc),
        .data_in((instruction[9] == 1'b0) ? x_out : y_out),
        .write_en(mem_write),
        .read_en(mem_read || (!mem_write && !mem_read)),
        .data_out(mem_data_out)
    );

    pc_unit pc_counter(
        .current_pc(current_pc),
        .branch_addr(immediate[9:0]),
        .pc_sel(pc_sel),
        .stack_data(reg_data_out),
        .next_pc(next_pc)
    );

    // ALU input selection
    // alu_a always comes from A register
    assign alu_a = a_out;
    
    // alu_b comes from either immediate or selected register (X or Y)
    wire [15:0] selected_register;
    assign selected_register = (instruction[9] == 1'b0) ? x_out : y_out;
    assign alu_b = use_immediate ? immediate : selected_register;

    assign instruction = mem_data_out;

endmodule