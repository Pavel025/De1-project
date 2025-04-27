library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
    generic(
        n_bits : integer := 14
    );
    Port ( clk   : in STD_LOGIC;
           echo1  : in STD_LOGIC;
           echo2  : in STD_LOGIC;
           echo3  : in STD_LOGIC;
           echo4  : in STD_LOGIC;
           trig1  : out STD_LOGIC;
           trig2  : out STD_LOGIC;
           trig3  : out STD_LOGIC;
           trig4  : out STD_LOGIC;
           count1 : out STD_LOGIC_VECTOR(n_bits downto 0);
           count2 : out STD_LOGIC_VECTOR(n_bits downto 0);
           count3 : out STD_LOGIC_VECTOR(n_bits downto 0);
           count4 : out STD_LOGIC_VECTOR(n_bits downto 0);
           clk_1MHz_out : out STD_LOGIC -- Jen pro simulaci
     );
end main;

architecture Behavioral of main is
    signal sig_count1 : unsigned(n_bits downto 0) := (others => '0');
    signal sig_count2 : unsigned(n_bits downto 0) := (others => '0');
    signal sig_count3 : unsigned(n_bits downto 0) := (others => '0');
    signal sig_count4 : unsigned(n_bits downto 0) := (others => '0');
    
    signal clk_1MHz_counter : unsigned(5 downto 0) := (others => '0');
    signal clk_1MHz : std_logic := '0';
    
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
            if echo1 = '1' then
                sig_count1 <= sig_count1 + 1;
            else
                if sig_count1 > 0 then
                    count1 <= std_logic_vector(sig_count1);
                    sig_count1 <= (others => '0');
                end if;
            end if;
            
            if echo2 = '1' then
                sig_count2 <= sig_count2 + 1;
            else
                if sig_count2 > 0 then
                    count2 <= std_logic_vector(sig_count2);
                    sig_count2 <= (others => '0');
                end if;
            end if;
            
            if echo3 = '1' then
                sig_count3 <= sig_count3 + 1;
            else
                if sig_count3 > 0 then
                    count3 <= std_logic_vector(sig_count3);
                    sig_count3 <= (others => '0');
                end if;
            end if;
            
            if echo4 = '1' then
                sig_count4 <= sig_count4 + 1;
            else
                if sig_count4 > 0 then
                    count4 <= std_logic_vector(sig_count4);
                    sig_count4 <= (others => '0');
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
            trig1 <= trig_active;
            trig2 <= trig_active;
            trig3 <= trig_active;
            trig4 <= trig_active;
        end if;
    end process;
        
end Behavioral;