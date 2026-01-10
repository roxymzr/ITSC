library verilog;
use verilog.vl_types.all;
entity aes_sbox_structural is
    port(
        data_in         : in     vl_logic_vector(15 downto 0);
        data_out        : out    vl_logic_vector(15 downto 0)
    );
end aes_sbox_structural;
