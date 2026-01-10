library verilog;
use verilog.vl_types.all;
entity aes_enc_round_structural is
    port(
        state           : in     vl_logic_vector(15 downto 0);
        round_key       : in     vl_logic_vector(15 downto 0);
        result          : out    vl_logic_vector(15 downto 0)
    );
end aes_enc_round_structural;
