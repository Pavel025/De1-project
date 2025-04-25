library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Buzzer is
    Port (
        clk   : in  std_logic;
        dist  : in  STD_LOGIC_VECTOR(14 downto 0);  -- 32 767 ~ 4 m
        beep  : out STD_LOGIC
    );
end Buzzer;

architecture Behavioral of Buzzer is
    constant CLK_FREQ : integer := 10_000_000; -- -- 100 M = 1 s => 10 ns  !!!!!!!!!

    signal dist_internal         : unsigned(14 downto 0);
    signal interval       : integer := 0;  -- ON + OFF
    signal beep_duration  : integer := 0;  -- ON
    signal counter        : integer := 0;
    signal beep_state     : std_logic := '0';
    signal counter_beep   : integer := 0;
    signal freg           : integer := 11364;
    
begin

    dist_internal <= unsigned(dist);

    process(clk)
    begin
        if rising_edge(clk) then

            -- délky intervalů
            if dist_internal < to_unsigned(8190, 15) then      -- 0.25 m
                interval      <= 2*CLK_FREQ;  -- 2 s
                beep_duration <= CLK_FREQ;  
            elsif dist_internal < to_unsigned(4095, 15) then  -- 0.5 m
                interval      <= 1*CLK_FREQ;   
                beep_duration <= CLK_FREQ/2;   
            elsif dist_internal < to_unsigned(2047, 15) then -- 1 m
                interval      <= CLK_FREQ/2;   
                beep_duration <= CLK_FREQ/4;   
            else
                interval      <= 0;       -- OFF
                beep_duration <= 0;
            end if;

            -- beep
            if interval = 0 then
                beep <= '0';
                counter <= 0;
                beep_state <= '0';
            else
                if counter < interval then
                    counter <= counter + 1;
                else
                    counter <= 0;
                end if;

                if counter < beep_duration then
                    if counter_beep < freg then
                         counter_beep <= counter_beep + 1;
                    else
                        counter_beep <= 0;
                        beep_state <= not beep_state;  -- beep ON
                    end if;
                    
                    
                else
                    beep_state <= '0';  -- beep OFF
                end if;

                beep <= beep_state;
            end if;
        end if;
    end process;

end Behavioral;
