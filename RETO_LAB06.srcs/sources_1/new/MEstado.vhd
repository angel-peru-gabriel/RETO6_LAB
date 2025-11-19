library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY MEstado IS
    PORT (
        clk2 : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        Valuein : IN STD_LOGIC;
        Estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        Sout : OUT STD_LOGIC);
END MEstado;

ARCHITECTURE Behavioral OF MEstado IS
    TYPE state_type IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, OK);
    SIGNAL current_state, next_state : state_type;

    CONSTANT SEQUENCE : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    FUNCTION expected_value(s : state_type) RETURN STD_LOGIC_VECTOR IS
    BEGIN
        CASE s IS
            WHEN S0 => RETURN "0000"; -- 0
            WHEN S1 => RETURN "0001"; -- 1
            WHEN S2 => RETURN "0010"; -- 2
            WHEN S3 => RETURN "0011"; -- 3
            WHEN S4 => RETURN "0100"; -- 4
            WHEN S5 => RETURN "0101"; -- 5
            WHEN S6 => RETURN "0110"; -- 6
            WHEN S7 => RETURN "0111"; -- 7
            WHEN S8 => RETURN "1000"; -- 8
            WHEN S9 => RETURN "1001"; -- 9
            WHEN S10 => RETURN "1010"; -- 10
            WHEN S11 => RETURN "1011"; -- 11
            WHEN OTHERS => RETURN "0000";
        END CASE;
    END FUNCTION;

BEGIN
    PROCESS (clk2, reset)
    BEGIN
        IF reset = '1' THEN
            current_state <= S0;
        ELSIF rising_edge(clk2) THEN
            current_state <= next_state;
        END IF;
    END PROCESS;
    PROCESS (current_state, Valuein)
    BEGIN
        CASE current_state IS
            WHEN S0 =>
                IF Valuein = '0' THEN
                    next_state <= S1;
                ELSE
                    next_state <= S0;
                END IF;
            WHEN S1 =>
                IF Valuein = '0' THEN
                    next_state <= S2;
                ELSE
                    next_state <= S0;
                END IF;
            WHEN S2 =>
                IF Valuein = '0' THEN
                    next_state <= S3;
                ELSE
                    next_state <= S0;
                END IF;
            WHEN S3 =>
                IF Valuein = '0' THEN
                    next_state <= S4;
                ELSE
                    next_state <= S0;
                END IF;
            WHEN S4 =>
                IF Valuein = '1' THEN
                    next_state <= S5;
                ELSE
                    next_state <= S4;
                END IF;

            WHEN S5 =>
                IF Valuein = '0' THEN
                    next_state <= S6;
                ELSE
                    next_state <= S0;
                END IF;
            WHEN S6 =>
                IF Valuein = '1' THEN
                    next_state <= S7;
                ELSE
                    next_state <= S2;
                END IF;
            WHEN S7 =>
                IF Valuein = '1' THEN
                    next_state <= S8;
                ELSE
                    next_state <= S1;
                END IF;
            WHEN S8 =>
                IF Valuein = '1' THEN
                    next_state <= S9;
                ELSE
                    next_state <= S1;
                END IF;
            WHEN S9 =>
                IF Valuein = '1' THEN
                    next_state <= S10;
                ELSE
                    next_state <= S1;
                END IF;
            WHEN S10 =>
                IF Valuein = '1' THEN
                    next_state <= S11;
                ELSE
                    next_state <= S1;
                END IF;
            WHEN S11 =>
                IF Valuein = '0' THEN
                    next_state <= OK;
                ELSE
                    next_state <= S0;
                END IF;
            WHEN OK => next_state <= OK;
        END CASE;
    END PROCESS;
    WITH current_state SELECT
        Estado <=
        "0000" WHEN S0,
        "0001" WHEN S1,
        "0010" WHEN S2,
        "0011" WHEN S3,
        "0100" WHEN S4,
        "0101" WHEN S5,
        "0110" WHEN S6,
        "0111" WHEN S7,
        "1000" WHEN S8,
        "1001" WHEN S9,
        "1010" WHEN S10,
        "1011" WHEN S11,
        "1100" WHEN OTHERS;
    Sout <= '1' WHEN current_state = OK ELSE
        '0';
END Behavioral;