library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity my_led is
    Port (
        clk     : in  STD_LOGIC;                     -- Hodinový signál (100 MHz)
        distance : in  STD_LOGIC_VECTOR(8 downto 0);  -- Vzdálenost v cm (9 bitů)
        red     : out STD_LOGIC;                     -- r
        green   : out STD_LOGIC;                     -- g
        blue    : out STD_LOGIC                      -- b
    );
end my_led;

architecture Behavioral of my_led is
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
    
    -- Logika pro nastavení intenzity podle vzdálenosti
    process(clk)
    begin
        if rising_edge(clk) then
            -- Výchozí stav: vše vypnuto
            red_duty   <= to_unsigned(0, 8);
            green_duty <= to_unsigned(0, 8);
            blue_duty  <= to_unsigned(0, 8);
            
            -- vzdalenosti, muzeme zmenit 
            if unsigned(distance) <= 25 then
                red_duty   <= to_unsigned(255, 8); -- Červená: 100% intenzita
            elsif unsigned(distance) <= 50 then
                red_duty   <= to_unsigned(255, 8); -- Oranžová: 100% červená
                green_duty <= to_unsigned(128, 8); -- 50% zelená
            elsif unsigned(distance) <= 75 then
                red_duty   <= to_unsigned(128, 8); -- Žlutá: 50% červená
                green_duty <= to_unsigned(255, 8); -- 100% zelená
            elsif unsigned(distance) <= 100 then
                green_duty <= to_unsigned(64, 8);  -- Světle zelená: 25% zelená
            else
                green_duty <= to_unsigned(255, 8); -- Zelená: 100% intenzita
            end if;
        end if;
    end process;
    
-- pwm signal pro barvy 
    red   <= '1' when pwm_counter < red_duty   else '0';
    green <= '1' when pwm_counter < green_duty else '0';
    blue  <= '1' when pwm_counter < blue_duty  else '0';
    
end Behavioral;