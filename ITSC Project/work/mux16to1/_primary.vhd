library verilog;
use verilog.vl_types.all;
entity mux16to1 is
    port(
        \in\            : in     vl_logic_vector(15 downto 0);
        sel             : in     vl_logic_vector(3 downto 0);
        \out\           : out    vl_logic
    );
end mux16to1;
