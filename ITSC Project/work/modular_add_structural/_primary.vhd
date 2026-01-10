library verilog;
use verilog.vl_types.all;
entity modular_add_structural is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        modulus         : in     vl_logic_vector(15 downto 0);
        result          : out    vl_logic_vector(15 downto 0);
        carry           : out    vl_logic
    );
end modular_add_structural;
