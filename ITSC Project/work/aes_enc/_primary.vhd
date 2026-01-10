library verilog;
use verilog.vl_types.all;
entity aes_enc is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        result          : out    vl_logic_vector(15 downto 0)
    );
end aes_enc;
