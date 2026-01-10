library verilog;
use verilog.vl_types.all;
entity control_unit is
    port(
        instruction     : in     vl_logic_vector(15 downto 0);
        flags           : in     vl_logic_vector(3 downto 0);
        alu_op          : out    vl_logic_vector(5 downto 0);
        reg_write_en    : out    vl_logic;
        reg_sel         : out    vl_logic_vector(2 downto 0);
        flag_write_en   : out    vl_logic;
        mem_read        : out    vl_logic;
        mem_write       : out    vl_logic;
        pc_sel          : out    vl_logic_vector(1 downto 0);
        immediate       : out    vl_logic_vector(15 downto 0);
        use_immediate   : out    vl_logic
    );
end control_unit;
