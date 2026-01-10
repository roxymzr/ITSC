library verilog;
use verilog.vl_types.all;
entity sbox_8bit is
    port(
        data_in         : in     vl_logic_vector(7 downto 0);
        data_out        : out    vl_logic_vector(7 downto 0)
    );
end sbox_8bit;
