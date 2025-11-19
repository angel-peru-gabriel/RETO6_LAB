-- ALU parametrizable según la Tabla propuesta (OPcode)
-- Operaciones: 0000->0, 0001->A AND B, 0010->A OR B, 0011->A NAND B,
--              0100->A NOR B, 0101->A XOR B, 0110->A XNOR B, 0111->A+B (unsigned),
--              1000->A-B (unsigned), 1001->A<<1, 1010->A>>1,
--              1011->(A=B ? 1 : 0), 1100->(A>B ? 1 : 0), otros -> todos '1'
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab_ALU is
  generic (
    data_width : integer := 4      -- ancho de palabra (bits)
  );
  port(
    InA, InB   : in  std_logic_vector(data_width-1 downto 0);
    OPcode     : in  std_logic_vector(3 downto 0);
    alu_out    : out std_logic_vector(data_width-1 downto 0);
    carry_flag : out std_logic;
    zero_flag  : out std_logic
  );
end entity;

architecture Behavioral of lab_ALU is
  -- Extendemos A y B a N+1 bits (bit extra para carry)
  signal InA_s  : unsigned(data_width downto 0);
  signal InB_s  : unsigned(data_width downto 0);

  -- Resultado en N+1 bits (para capturar carry en el bit superior)
  signal result : unsigned(data_width downto 0);
begin
  -- Extensión con 0 en el MSB (evita signo y habilita carry)
  InA_s <= '0' & unsigned(InA);
  InB_s <= '0' & unsigned(InB);

  -- Proceso COMBINACIONAL: sensible a todas las entradas leídas
  process(InA_s, InB_s, OPcode)
    variable R : unsigned(data_width downto 0);  -- variable local para armar el resultado
    -- alias a N bits (parte baja) por comodidad en operaciones lógicas puras
    variable A_lo, B_lo : unsigned(data_width-1 downto 0);
  begin
    A_lo := InA_s(data_width-1 downto 0);
    B_lo := InB_s(data_width-1 downto 0);
    R    := (others => '0');

    case OPcode is
      when "0000" =>                     -- todos los bits '0'
        R := (others => '0');

      when "0001" =>                     -- A AND B
        R(data_width-1 downto 0) := A_lo and B_lo;
        R(data_width)            := '0';

      when "0010" =>                     -- A OR B
        R(data_width-1 downto 0) := A_lo or B_lo;
        R(data_width)            := '0';

      when "0011" =>                     -- A NAND B
        R(data_width-1 downto 0) := not (A_lo and B_lo);
        R(data_width)            := '0';

      when "0100" =>                     -- A NOR B
        R(data_width-1 downto 0) := not (A_lo or B_lo);
        R(data_width)            := '0';

      when "0101" =>                     -- A XOR B
        R(data_width-1 downto 0) := A_lo xor B_lo;
        R(data_width)            := '0';

      when "0110" =>                     -- A XNOR B
        R(data_width-1 downto 0) := not (A_lo xor B_lo);
        R(data_width)            := '0';

      when "0111" =>                     -- A + B (unsigned)
        R := InA_s + InB_s;              -- suma en N+1 bits (carry en MSB)

      when "1000" =>                     -- A - B (unsigned)
        R := InA_s - InB_s;              -- resta en N+1 bits (borrow reflejado en MSB como carry según suma/resta de módulo 2^(N+1))

      when "1001" =>                     -- A « 1 (desplazar a la izquierda)
        R := (others => '0');
        -- Shift lógico: desplaza N bits bajos, descarta MSB y mete '0' en LSB
        R(data_width-1 downto 0) := shift_left(A_lo, 1);
        -- El bit que se cae (MSB de A) lo podrías usar como carry si el profe lo pide:
        R(data_width) := A_lo(data_width-1);

      when "1010" =>                     -- A » 1 (desplazar a la derecha)
        R := (others => '0');
        R(data_width-1 downto 0) := shift_right(A_lo, 1);
        -- El bit que se cae (LSB de A) puede enviarse al carry (opcional):
        R(data_width) := A_lo(0);

      when "1011" =>                     -- '1' si A = B, en caso contrario '0'
        R := (others => '0');
        if A_lo = B_lo then
          R(0) := '1';
        end if;

      when "1100" =>                     -- '1' si A > B, en caso contrario '0'
        R := (others => '0');
        if A_lo > B_lo then
          R(0) := '1';
        end if;

      when others =>                     -- por defecto: todos '1' (como tu guía)
        R := (others => '1');
    end case;

    result <= R;                          -- volcamos la variable al signal
  end process;

  -- Salidas concurrentes (no hace falta otro process)
  alu_out    <= std_logic_vector(result(data_width-1 downto 0));               -- N bits bajos
  carry_flag <= result(data_width);                                            -- MSB (carry/borrow/bit caído en shifts)
  zero_flag  <= '1' when unsigned(result(data_width-1 downto 0)) = to_unsigned(0, data_width) else '0';
end architecture;
