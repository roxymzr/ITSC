library verilog;
use verilog.vl_types.all;
entity reg_file is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        reg_sel         : in     vl_logic_vector(2 downto 0);
        data_in         : in     vl_logic_vector(15 downto 0);
        write_en        : in     vl_logic;
        data_out        : out    vl_logic_vector(15 downto 0);
        flag_in         : in     vl_logic_vector(3 downto 0);
        flag_write_en   : in     vl_logic;
        flags_out       : out    vl_logic_vector(3 downto 0);
        reg_a           : out    vl_logic_vector(15 downto 0);
        reg_x           : out    vl_logic_vector(15 downto 0);
        reg_y           : out    vl_logic_vector(15 downto 0);
        reg_sp          : out    vl_logic_vector(15 downto 0)
    );
end reg_file;
