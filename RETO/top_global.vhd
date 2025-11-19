library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY top_global IS
    PORT (
        clk_Basys : IN STD_LOGIC;
        valueln, clk2, reset : IN STD_LOGIC;
        displays : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        segment7 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        Estado : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END top_global;



ARCHITECTURE Behavioral OF top_global IS
    COMPONENT MEstado IS
        PORT (
            clk2 : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            Valuein : IN STD_LOGIC;
            Estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            Sout : OUT STD_LOGIC);
    END COMPONENT;


    COMPONENT Clock_Divider IS
        PORT (
            clkb : IN STD_LOGIC;
            clock_out : OUT STD_LOGIC);
    END COMPONENT;


    COMPONENT display_cuatro IS
        PORT (
            clk : IN STD_LOGIC;
            en : IN STD_LOGIC;
            seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            endd : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
    END COMPONENT;

    SIGNAL Sout : STD_LOGIC;
    SIGNAL clk_out : STD_LOGIC;
BEGIN
    Mestado1 : MEstado
    PORT MAP(
        clk2 => clk2,
        Valuein => Valueln,
        reset => reset,
        estado => estado, 
        Sout => Sout);
    
    Div_CLK : Clock_Divider
    PORT MAP(
        clkb => clk_Basys,
        clock_out => clk_out);
    Display : display_cuatro
    
    PORT MAP(
        clk => clk_out, 
        en => Sout,
        endd => displays, 
        seg => segment7);
END Behavioral;