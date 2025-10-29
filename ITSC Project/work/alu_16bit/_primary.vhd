library verilog;
use verilog.vl_types.all;
entity alu_16bit is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        opcode          : in     vl_logic_vector(5 downto 0);
        \out\           : out    vl_logic_vector(15 downto 0);
        zero            : out    vl_logic;
        negative        : out    vl_logic;
        carry           : out    vl_logic;
        overflow        : out    vl_logic
    );
end alu_16bit;
