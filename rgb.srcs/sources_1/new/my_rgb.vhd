library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rgb_pwm is
    Port (
        clk     : in  STD_LOGIC;                     -- Hodinový signál (100 MHz)
        my_dist : in  STD_LOGIC_VECTOR(8 downto 0);  -- Vzdálenost v cm (9 bitů)
        red     : out STD_LOGIC;                     -- r
        green   : out STD_LOGIC;                     -- g
        blue    : out STD_LOGIC                      -- b
    );
end rgb_pwm;

architecture Behavioral of rgb_pwm is
    -- PWM čítač (8 bitů, perioda 256 cyklů)
    -- pomocné signály
    signal pwm_counter : unsigned(7 downto 0) := (others => '0');
    
    -- Signály pro duty cycle (intenzita) každého kanálu
    signal red_duty   : unsigned(7 downto 0) := (others => '0');
    signal green_duty : unsigned(7 downto 0) := (others => '0');
    signal blue_duty  : unsigned(7 downto 0) := (others => '0');
    
begin
    -- PWM čítač (pořád běží)
    -- Frekvence PWM = 100 MHz / 256 = 390 kHz to je asi dost na to, aby to blikání nebylo vidět 
    process(clk)
    begin
        if rising_edge(clk) then
            pwm_counter <= pwm_counter + 1; -- Inkrementace čítače (0-255)
        end if;
    end process;
    
    -- nastavení vzdálenosti
    process(clk)
    begin
        if rising_edge(clk) then
            -- Výchozí stav:  vypnuto
            red_duty   <= to_unsigned(0, 8);
            green_duty <= to_unsigned(0, 8);
            blue_duty  <= to_unsigned(0, 8);
            
            -- vzdalenosti
            if unsigned(my_dist) <= 25 then
                red_duty   <= to_unsigned(255, 8); -- r 100% 
            elsif unsigned(my_dist) <= 50 then
                red_duty   <= to_unsigned(255, 8); -- r 100%
                green_duty <= to_unsigned(128, 8); -- g 50% 
            elsif unsigned(my_dist) <= 75 then
                red_duty   <= to_unsigned(128, 8); -- r 50% 
                green_duty <= to_unsigned(255, 8); -- g 100%
            elsif unsigned(my_dist) <= 100 then
                green_duty <= to_unsigned(64, 8);  -- g 25% 
            else
                green_duty <= to_unsigned(255, 8); -- g 100%
            end if;
        end if;
    end process;
    
-- pwm signal pro barvy 
    red   <= '1' when pwm_counter < red_duty   else '0';
    green <= '1' when pwm_counter < green_duty else '0';
    blue  <= '1' when pwm_counter < blue_duty  else '0';
    
end Behavioral;