library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
    generic(
        n_bits : integer := 14
    );
    Port (
        clk    : in  STD_LOGIC;  -- 100 MHz vstupní hodiny
        echo   : in  STD_LOGIC;
        impuls : out STD_LOGIC;
        trig   : out STD_LOGIC;
        count  : out STD_LOGIC_VECTOR(n_bits downto 0) := (others => '0')
    );
end main;

architecture Behavioral of main is

    -- Dělička hodin pro 1 MHz (perioda 1 µs)
    signal clk_1MHz     : std_logic := '0';
    signal clk_div_cnt  : unsigned(6 downto 0) := (others => '0'); -- počítá do 49

    -- Počítadla pro impulzy a echo
    signal sig_count    : unsigned(n_bits downto 0) := (others => '0');
    signal clk_counter  : integer := 0;
    signal pulse_reg    : std_logic := '0';

    constant PULSE_PERIOD : integer := 60000; -- 60 ms při 1 MHz = 60 000 cyklů
    constant PULSE_WIDTH  : integer := 10;    -- 10 µs při 1 MHz = 10 cyklů

begin

    -- Proces: dělička hodin 100 MHz → 1 MHz
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_div_cnt = 49 then
                clk_div_cnt <= (others => '0');
                clk_1MHz <= not clk_1MHz;
            else
                clk_div_cnt <= clk_div_cnt + 1;
            end if;
        end if;
    end process;

    -- Hlavní proces řízený 1MHz hodinami
    process(clk_1MHz)
    begin
        if rising_edge(clk_1MHz) then
            -- Generování impulzu každých 60 ms
            if clk_counter < PULSE_PERIOD - 1 then
                clk_counter <= clk_counter + 1;
            else
                clk_counter <= 0;
            end if;

            if clk_counter < PULSE_WIDTH then
                pulse_reg <= '1';
            else
                pulse_reg <= '0';
            end if;

            -- Měření trvání signálu echo
            if echo = '1' then
                sig_count <= sig_count + 1;
            else
                count <= std_logic_vector(sig_count);
                sig_count <= (others => '0');
            end if;
        end if;
    end process;

    impuls <= pulse_reg;

end Behavioral;
