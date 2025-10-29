// memory_debug.v
module memory(
    input clk,
    input [15:0] address,
    input [15:0] data_in,
    input write_en,
    input read_en,
    output reg [15:0] data_out
);

    reg [15:0] mem [0:15];
    
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            mem[i] = 16'b0;
        end
        
        // ENHANCED TEST PROGRAM with debug info in comments
        mem[0] = {`OP_LDI, `REG_X, 9'h005};  // LDI X, 5   -> X=5
        mem[1] = {`OP_LDI, `REG_Y, 9'h003};  // LDI Y, 3   -> Y=3
        mem[2] = {`OP_MOV, `REG_X, 9'h000};  // MOV A, X   -> A=5
        mem[3] = {`OP_ADD, `REG_Y, 9'h000};  // ADD Y      -> A=8
        mem[4] = {`OP_BRA, 10'h004};         // BRA 4      -> loop forever
        
        data_out = 16'b0;
        
        $display("=== MEMORY INITIALIZED ===");
        $display("Address 0: LDI X, 5");
        $display("Address 1: LDI Y, 3"); 
        $display("Address 2: MOV A, X");
        $display("Address 3: ADD Y");
        $display("Address 4: BRA 4");
    end

    always @(posedge clk) begin
        if (write_en && address < 16) begin
            mem[address] <= data_in;
            $display("Memory Write: address=%h, data=%h", address, data_in);
        end
    end

    always @(*) begin
        if (read_en && address < 16) begin
            data_out = mem[address];
        end else begin
            data_out = 16'b0;
        end
    end

endmodule