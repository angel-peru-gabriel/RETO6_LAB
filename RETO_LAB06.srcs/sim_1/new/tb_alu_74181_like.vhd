library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alu_74181_like is
end entity;

architecture sim of tb_alu_74181_like is
  constant N : natural := 4;

  -- DUT
  component alu_74181_like
    generic ( N : natural := 4 );
    port (
      A, B  : in  std_logic_vector(N-1 downto 0);
      S     : in  std_logic_vector(3 downto 0);
      M     : in  std_logic;
      Cn    : in  std_logic;
      F     : out std_logic_vector(N-1 downto 0);
      Cout  : out std_logic;
      Z     : out std_logic
    );
  end component;

  -- Señales del DUT
  signal A    : std_logic_vector(N-1 downto 0) := (others=>'0');
  signal B    : std_logic_vector(N-1 downto 0) := (others=>'0');
  signal S    : std_logic_vector(3 downto 0)   := (others=>'0');
  signal M    : std_logic := '1';
  signal Cn   : std_logic := '1';
  signal F    : std_logic_vector(N-1 downto 0);
  signal Cout : std_logic;
  signal Z    : std_logic;

  -- Conjunto de vectores de prueba "representativos"
  type vec4_t is array (natural range <>) of std_logic_vector(3 downto 0);
  constant VSET : vec4_t := (
    "0000",  -- 0
    "0011",  -- 3
    "0101",  -- 5
    "1010",  -- A
    "1111"   -- F
  );

  -- Utilidad para pretty-print
  function slv4_hex(s : std_logic_vector(3 downto 0)) return string is
    variable u : unsigned(3 downto 0) := unsigned(s);
    constant hexchars : string := "0123456789ABCDEF";
  begin
    return "" & hexchars(to_integer(u)+1);
  end function;

begin
  -- Instancia del DUT
  UUT : alu_74181_like
    generic map ( N => N )
    port map (
      A    => A,
      B    => B,
      S    => S,
      M    => M,
      Cn   => Cn,
      F    => F,
      Cout => Cout,
      Z    => Z
    );

  --------------------------------------------------------------------
  -- ESTÍMULOS
  --------------------------------------------------------------------
  stim : process
    variable ia, ib : integer;
    variable s_idx  : integer;
  begin
    report "==== INICIO SIMULACION ALU 74181 (ACTIVE-HIGH DATA) ====" severity note;

    ----------------------------------------------------------------
    -- Batería 1: MODO LOGICO (M=1) - Cn no afecta
    ----------------------------------------------------------------
    M  <= '1';
    Cn <= '1';  -- sin impacto en modo lógico

    for s_idx   in 0 to 15 loop
      S <= std_logic_vector(to_unsigned(iS,4));
      for ia in VSET'range loop
        A <= VSET(ia);
        for ib in VSET'range loop
          B <= VSET(ib);
          wait for 10 ns;

          report "LOGIC  M=" & character'VALUE(integer'IMAGE(to_integer(unsigned(M))))
              & "  S=" & slv4_hex(S)
              & "  A=" & slv4_hex(A) & "  B=" & slv4_hex(B)
              & "  -> F=" & slv4_hex(F)
              & "  Z=" & character'VALUE(integer'IMAGE(to_integer(unsigned(Z))))
            severity note;
        end loop;
      end loop;
    end loop;

    ----------------------------------------------------------------
    -- Batería 2: MODO ARITMETICO (M=0) con y sin carry (Tabla 2)
    ----------------------------------------------------------------
    M <= '0';

    -- Primero: Cn='1' (NO carry)
    Cn <= '1';
    for iS in 0 to 15 loop
      S <= std_logic_vector(to_unsigned(iS,4));
      for ia in VSET'range loop
        A <= VSET(ia);
        for ib in VSET'range loop
          B <= VSET(ib);
          wait for 10 ns;
          report "ARITH NC  M=0 Cn=1 S=" & slv4_hex(S)
             & " A=" & slv4_hex(A) & " B=" & slv4_hex(B)
             & " -> F=" & slv4_hex(F) & " Cout=" & character'VALUE(integer'IMAGE(to_integer(unsigned(Cout))))
             & " Z=" & character'VALUE(integer'IMAGE(to_integer(unsigned(Z))))
           severity note;
        end loop;
      end loop;
    end loop;

    -- Luego: Cn='0' (WITH carry ? +1)
    Cn <= '0';
    for iS in 0 to 15 loop
      S <= std_logic_vector(to_unsigned(iS,4));
      for ia in VSET'range loop
        A <= VSET(ia);
        for ib in VSET'range loop
          B <= VSET(ib);
          wait for 10 ns;
          report "ARITH WC  M=0 Cn=0 S=" & slv4_hex(S)
             & " A=" & slv4_hex(A) & " B=" & slv4_hex(B)
             & " -> F=" & slv4_hex(F) & " Cout=" & character'VALUE(integer'IMAGE(to_integer(unsigned(Cout))))
             & " Z=" & character'VALUE(integer'IMAGE(to_integer(unsigned(Z))))
           severity note;
        end loop;
      end loop;
    end loop;

    report "==== FIN SIMULACION ====" severity note;
    wait;
  end process;

  --------------------------------------------------------------------
  -- (OPCIONAL) Versión EXHAUSTIVA
  -- Descomenta para barrer TODAS las combinaciones A,B=0..15 (más lento)
  --------------------------------------------------------------------
  --[[
  --exhaustive : process
  --  variable a_int, b_int, s_int : integer;
  --begin
  --  wait for 1 us; -- esperar a que termine la prueba corta
  --  M <= '0'; Cn <= '0';
  --  for s_int in 0 to 15 loop
  --    S <= std_logic_vector(to_unsigned(s_int,4));
  --    for a_int in 0 to 15 loop
  --      A <= std_logic_vector(to_unsigned(a_int,4));
  --      for b_int in 0 to 15 loop
  --        B <= std_logic_vector(to_unsigned(b_int,4));
  --        wait for 2 ns;
  --      end loop;
  --    end loop;
  --  end loop;
  --  wait;
  --end process;
  --]]
end architecture;
