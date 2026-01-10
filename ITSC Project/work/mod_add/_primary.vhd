library verilog;
use verilog.vl_types.all;
entity mod_add is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        result          : out    vl_logic_vector(15 downto 0);
        carry           : out    vl_logic
    );
end mod_add;
