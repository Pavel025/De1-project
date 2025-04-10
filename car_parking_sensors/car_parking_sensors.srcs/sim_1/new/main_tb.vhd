-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 10 Apr 2025 17:30:36 GMT
-- Request id : cfwk-fed377c2-67f8003cccff8

library ieee;
    use ieee.std_logic_1164.all;

entity tb_main is
end entity tb_main;

architecture tb of tb_main is

    component main
        generic (
            n_bits : integer
        );
        port (clk   : in std_logic;
              echo  : in std_logic;
              trig  : out std_logic;
              count : out std_logic_vector (n_bits downto 0));
    end component;

    constant c_nbits : integer := 14;  
    signal clk   : std_logic;
    signal echo  : std_logic;
    signal trig  : std_logic;
    signal count : std_logic_vector (c_nbits downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : component main
    generic map (
        n_bits => c_nbits
        )
    port map (clk   => clk,
              echo  => echo,
              trig  => trig,
              count => count);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process is
    begin
        -- ***EDIT*** Adapt initialization as needed
        echo <= '0';
        wait for 50 ns;
        echo <= '1';
        wait for 500 ns;
        echo <= '0';

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end architecture tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_main of tb_main is
    for tb
    end for;
end cfg_tb_main;