-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 24 Apr 2025 18:59:40 GMT
-- Request id : cfwk-fed377c2-680a8a1cceeb0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Buzzer is
end tb_Buzzer;

architecture tb of tb_Buzzer is

    component Buzzer
        port (clk  : in std_logic;
              dist : in std_logic_vector (8 downto 0);
              beep : out std_logic);
    end component;

    signal clk  : std_logic;
    signal dist : std_logic_vector (8 downto 0);
    signal beep : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Buzzer
    port map (clk  => clk,
              dist => dist,
              beep => beep);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        dist <= (others => '0');
        wait for 100 ns;
        -- Reset generation
        --  ***EDIT*** Replace YOURRESETSIGNAL below by the name of your reset as I haven't guessed it
        dist <= std_logic_vector(to_unsigned(120, 9));
        wait for 500 ns;
        dist <= std_logic_vector(to_unsigned(70, 9));
        wait for 3000 ns;
        dist <= std_logic_vector(to_unsigned(45, 9));
        wait for 1500 ns;
        dist <= std_logic_vector(to_unsigned(20, 9));
        wait for 1500 ns;
        -- ***EDIT*** Add stimuli here
       

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Buzzer of tb_Buzzer is
    for tb
    end for;
end cfg_tb_Buzzer;