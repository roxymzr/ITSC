library verilog;
use verilog.vl_types.all;
entity cpu_top is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        pc_out          : out    vl_logic_vector(15 downto 0);
        a_out           : out    vl_logic_vector(15 downto 0);
        x_out           : out    vl_logic_vector(15 downto 0);
        y_out           : out    vl_logic_vector(15 downto 0);
        flags_out       : out    vl_logic_vector(3 downto 0)
    );
end cpu_top;
