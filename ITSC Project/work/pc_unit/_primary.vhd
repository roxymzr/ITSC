library verilog;
use verilog.vl_types.all;
entity pc_unit is
    port(
        current_pc      : in     vl_logic_vector(15 downto 0);
        branch_addr     : in     vl_logic_vector(9 downto 0);
        pc_sel          : in     vl_logic_vector(1 downto 0);
        stack_data      : in     vl_logic_vector(15 downto 0);
        next_pc         : out    vl_logic_vector(15 downto 0)
    );
end pc_unit;
