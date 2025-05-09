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
            clk         : in std_logic;
            echo1       : in std_logic;
            echo2       : in std_logic;
            echo3       : in std_logic;
            echo4       : in std_logic;
            trig1       : out std_logic;
            trig2       : out std_logic;
            trig3       : out std_logic;
            trig4       : out std_logic;
            count1      : out std_logic_vector(n_bits downto 0);
            count2      : out std_logic_vector(n_bits downto 0);
            count3      : out std_logic_vector(n_bits downto 0);
            count4      : out std_logic_vector(n_bits downto 0);
            clk_1MHz_out : out std_logic
        );
    end component;

    constant c_nbits : integer := 14;  

    signal clk         : std_logic := '0';
    signal echo1       : std_logic := '0';
    signal echo2       : std_logic := '0';
    signal echo3       : std_logic := '0';
    signal echo4       : std_logic := '0';
    signal trig1       : std_logic := '0';
    signal trig2       : std_logic := '0';
    signal trig3       : std_logic := '0';
    signal trig4       : std_logic := '0';
    signal count1      : std_logic_vector(c_nbits downto 0) := (others => '0');
    signal count2      : std_logic_vector(c_nbits downto 0) := (others => '0');
    signal count3      : std_logic_vector(c_nbits downto 0) := (others => '0');
    signal count4      : std_logic_vector(c_nbits downto 0) := (others => '0');
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
            clk         => clk,
            echo1       => echo1,
            echo2       => echo2,
            echo3       => echo3,
            echo4       => echo4,
            trig1       => trig1,
            trig2       => trig2,
            trig3       => trig3,
            trig4       => trig4,
            count1      => count1,
            count2      => count2,
            count3      => count3,
            count4      => count4,
            clk_1MHz_out => clk_1MHz_out
        );

    -- Hodiny 100 MHz
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
        -- simulace pulzů echo pro každý vstup zvlášť

--        echo1 <= '1';
--        echo2 <= '1';
--        echo3 <= '1';
--        echo4 <= '1';
--        wait for 5 ms;
--        echo1 <= '0';
--        wait for 5 ms;
--        echo2 <= '0';
--        wait for 5 ms;
--        echo3 <= '0';
--        wait for 5 ms;
--        echo4 <= '0';

--        wait for 10 ms;
        
--        echo1 <= '1';
--        wait for 3 ms;
--        echo2 <= '1';
--        wait for 6 ms;
--        echo1 <= '0';
--        wait for 7 ms;
--        echo2 <= '0';

--        echo1 <= '1';
--        echo2 <= '1';
--        echo3 <= '1';
--        echo4 <= '1';
--        wait for 1 ms;
--        echo1 <= '0';
--        echo2 <= '0';
--        echo3 <= '0';
--        echo4 <= '0';
        
--        wait for 200 ms;

        wait for 1 ms;
        
        TbSimEnded <= '1';
    end process;

end architecture tb;

configuration cfg_tb_main of tb_main is
    for tb
    end for;
end cfg_tb_main;