library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY Clock_Divider IS
    PORT (
        clkb : IN STD_LOGIC;
        clock_out : OUT STD_LOGIC);
END Clock_Divider;


ARCHITECTURE bhv OF Clock_Divider IS
    SIGNAL count : INTEGER := 1;
    SIGNAL tmp : STD_LOGIC := '0';

BEGIN
    PROCESS (clkb)
    BEGIN
        IF (clkb'event AND clkb = '1') THEN
            count <= count + 1;
            IF (count = 100000) THEN -- Cambiado a 1,000,000
                --para obtener 100 Hz
                tmp <= NOT tmp;
                count <= 1;
            END IF;
        END IF;
        clock_out <= tmp;
    END PROCESS;
END bhv;