library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY display_cuatro IS
    PORT (
        clk  : IN STD_LOGIC;
        en   : IN STD_LOGIC;
        seg  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        endd : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END display_cuatro;

ARCHITECTURE Behavioral OF display_cuatro IS
    SIGNAL ds1   : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1110001"; -- L
    SIGNAL ds2   : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1100000"; -- b
    SIGNAL ds3   : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1001111"; -- 1
    SIGNAL ds4   : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000001"; -- 0
    SIGNAL count : unsigned(1 DOWNTO 0) := "00";
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF en = '1' THEN
                -- cuando está habilitado, cuento y muestro L b 1 0
                count <= count + 1;

                CASE count IS
                    WHEN "00" =>
                        seg  <= ds1;
                        endd <= "0111";
                    WHEN "01" =>
                        seg  <= ds2;
                        endd <= "1011";
                    WHEN "10" =>
                        seg  <= ds3;
                        endd <= "1101";
                    WHEN OTHERS =>
                        seg  <= ds4;
                        endd <= "1110";
                END CASE;

            ELSE
                -- cuando en = '0', apago todo
                seg  <= (others => '1');  -- nada encendido
                endd <= "1111";           -- todos los displays apagados
                count <= "00";            -- opcional: volver al inicio
            END IF;
        END IF;
    END PROCESS;
END Behavioral;
