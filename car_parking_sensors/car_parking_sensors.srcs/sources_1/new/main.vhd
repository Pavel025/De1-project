library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
    generic(
        n_bits : integer := 14
    );
    Port ( clk   : in STD_LOGIC;
           echo  : in STD_LOGIC;
           trig  : out STD_LOGIC;
           count : out STD_LOGIC_VECTOR(n_bits downto 0);
           clk_1MHz_out : out STD_LOGIC -- Jen pro simulaci
     );
end main;

architecture Behavioral of main is
    signal sig_count : unsigned(n_bits downto 0) := (others => '0');
    
    signal clk_1MHz_counter : unsigned(5 downto 0) := (others => '0');
    signal clk_1MHz : std_logic := '0';
    
    signal hold : std_logic := '0';
    
    signal counter_60ms : unsigned(16 downto 0) := (others => '0');
    signal counter_10us : unsigned(3 downto 0) := (others => '0');
    signal trig_active : std_logic := '0';
        
begin

    clk_1MHz_out <= clk_1MHz; -- Jen pro simulaci
    
    -- HODINY 1us
    process (clk)
    begin
        if rising_edge(clk) then
            if clk_1MHz_counter = 49 then
                clk_1MHz <= not clk_1MHz;
                clk_1MHz_counter <= (others => '0');
            else
                clk_1MHz_counter <= clk_1MHz_counter + 1;
            end if;
        end if;              
    end process;
    
    
    -- STOPKY
    process (clk_1MHz)
    begin   
        if rising_edge(clk_1MHz) then
            if echo = '1' then
                sig_count <= sig_count + 1;
            else
                if sig_count > 0 then
                    count <= std_logic_vector(sig_count);
                    sig_count <= (others => '0');
                end if;
            end if;
            

            if counter_60ms = 59999 then
                trig_active <= '1';
                counter_60ms <= (others => '0');
            elsif trig_active = '1' then
                if counter_10us = 9 then
                    trig_active <= '0';
                    counter_10us <= (others => '0');
                else 
                    counter_10us <= counter_10us + 1;
                end if;
            else 
                counter_60ms <= counter_60ms + 1;
            end if;
            trig <= trig_active;
        end if;
    end process;
        
end Behavioral;