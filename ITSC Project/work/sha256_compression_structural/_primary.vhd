library verilog;
use verilog.vl_types.all;
entity sha256_compression_structural is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        c               : in     vl_logic_vector(15 downto 0);
        d               : in     vl_logic_vector(15 downto 0);
        result          : out    vl_logic_vector(15 downto 0)
    );
end sha256_compression_structural;
