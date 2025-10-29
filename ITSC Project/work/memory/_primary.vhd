library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        clk             : in     vl_logic;
        address         : in     vl_logic_vector(15 downto 0);
        data_in         : in     vl_logic_vector(15 downto 0);
        write_en        : in     vl_logic;
        read_en         : in     vl_logic;
        data_out        : out    vl_logic_vector(15 downto 0)
    );
end memory;
