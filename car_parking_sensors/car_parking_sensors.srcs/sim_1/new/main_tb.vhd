library ieee;
use ieee.std_logic_1164.all;

entity tb_main is
end entity tb_main;

architecture tb of tb_main is

    component main
        generic (
            n_bits : integer
        );
        port (
            clk    : in std_logic;
            echo   : in std_logic;
            trig   : out std_logic;
            count  : out std_logic_vector(n_bits downto 0);
            clk_1MHz_out : out std_logic
        );
    end component;

    constant c_nbits : integer := 14;  
    signal clk    : std_logic := '0';
    signal echo   : std_logic := '0';
    signal trig   : std_logic;
    signal count  : std_logic_vector(c_nbits downto 0);
    signal clk_1MHz_out : std_logic;

    constant TbPeriod : time := 10 ns; -- 100 MHz hodiny
    signal TbSimEnded : std_logic := '0';

begin

    -- DUT instance
    dut : main
        generic map (
            n_bits => c_nbits
        )
        port map (
            clk    => clk,
            echo   => echo,
            trig   => trig,
            count  => count,
            clk_1MHz_out => clk_1MHz_out
        );

    -- Clock generation (100 MHz)
    clk_gen : process
    begin
        while TbSimEnded = '0' loop
            clk <= '0';
            wait for TbPeriod / 2;
            clk <= '1';
            wait for TbPeriod / 2;
        end loop;
        wait;
    end process;

    -- Stimuli generation
    stimuli : process
    begin
        -- Čekej na začátek simulace
        wait for 2 ms;

        -- První echo pulz - 50 µs
        echo <= '1';
        wait for 50 us;
        echo <= '0';

        wait for 5 ms;

        -- Druhý echo pulz - 100 µs
        echo <= '1';
        wait for 100 us;
        echo <= '0';

        wait for 10 ms;

        -- Třetí echo pulz - 200 µs
        echo <= '1';
        wait for 200 us;
        echo <= '0';

        -- Konec simulace
        wait for 10 ms;
        TbSimEnded <= '1';
        wait;
    end process;

end architecture tb;

configuration cfg_tb_main of tb_main is
    for tb
    end for;
end cfg_tb_main;
