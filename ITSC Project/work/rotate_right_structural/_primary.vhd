library verilog;
use verilog.vl_types.all;
entity rotate_right_structural is
    port(
        data            : in     vl_logic_vector(15 downto 0);
        amount          : in     vl_logic_vector(3 downto 0);
        result          : out    vl_logic_vector(15 downto 0)
    );
end rotate_right_structural;
