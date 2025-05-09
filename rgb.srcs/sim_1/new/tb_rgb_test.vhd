library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_rgb_test is
end tb_rgb_test;

architecture Behavioral of tb_rgb_test is
    -- Signály pro připojení k entitě
    signal clk     : STD_LOGIC := '0';
    signal my_dist : STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
    signal red     : STD_LOGIC;
    signal green   : STD_LOGIC;
    signal blue    : STD_LOGIC;
    
    -- Konstanty pro simulaci
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz hodiny
    constant PWM_PERIOD : time := 256 * CLK_PERIOD; -- 8bitový PWM čítač
    constant TEST_DURATION : time := 10 * PWM_PERIOD; -- 10 PWM period na test
    
begin
    -- Instance testované entity
    uut: entity work.rgb_pwm
        port map (
            clk     => clk,
            my_dist => my_dist,
            red     => red,
            green   => green,
            blue    => blue
        );
    
    -- Generování hodinového signálu
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;
    
    -- Stimulační proces
    stim_proc: process
    begin
        -- Inicializace
        my_dist <= (others => '0');
        wait for 100 ns; -- Počáteční čekání pro stabilizaci
        
        -- Test 1: 0 cm (červená, 100%)
        my_dist <= std_logic_vector(to_unsigned(0, 9));
        wait for TEST_DURATION;
        
        -- Test 2: 25 cm (červená, 100%)
        my_dist <= std_logic_vector(to_unsigned(25, 9));
        wait for TEST_DURATION;
        
        -- Test 3: 37 cm (oranžová: 100% červená, 50% zelená)
        my_dist <= std_logic_vector(to_unsigned(37, 9));
        wait for TEST_DURATION;
        
        -- Test 4: 62 cm (žlutá: 50% červená, 100% zelená)
        my_dist <= std_logic_vector(to_unsigned(62, 9));
        wait for TEST_DURATION;
        
        -- Test 5: 87 cm (světle zelená: 25% zelená)
        my_dist <= std_logic_vector(to_unsigned(87, 9));
        wait for TEST_DURATION;
        
        -- Test 6: 150 cm (zelená: 100% zelená)
        my_dist <= std_logic_vector(to_unsigned(150, 9));
        wait for TEST_DURATION;
        
        -- Konec simulace
        wait;
    end process;
    
end Behavioral;