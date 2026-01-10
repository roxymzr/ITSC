library verilog;
use verilog.vl_types.all;
entity gf_multiply is
    port(
        a               : in     vl_logic_vector(7 downto 0);
        b               : in     vl_logic_vector(7 downto 0);
        result          : out    vl_logic_vector(7 downto 0)
    );
end gf_multiply;
