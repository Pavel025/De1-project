library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity obstacle_dir_disp is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        time1       : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 1
        time2       : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 2
        time3       : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 3
        time4       : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 4
        seg1        : out STD_LOGIC_VECTOR(6 downto 0);   -- jednotky
        seg2        : out STD_LOGIC_VECTOR(6 downto 0);    -- desítky
        seg3        : out STD_LOGIC_VECTOR(6 downto 0)   -- směr
    );


end obstacle_dir_disp;

architecture Behavioral of obstacle_dir_disp is
    signal dist1, dist2, dist3, dist4 : integer := 0;
    signal min_dist                   : integer := 0;
    signal tens, ones                 : integer := 0;
    signal min_sensor : integer := 0;


begin

    process(clk, reset)
    begin
        if reset = '1' then
            dist1 <= 0; dist2 <= 0; dist3 <= 0; dist4 <= 0;
            min_dist <= 0;
        elsif rising_edge(clk) then
                    -- distX <= time * 17 / 100
            dist1 <= to_integer(unsigned(time1)) * 17 / 100;
            dist2 <= to_integer(unsigned(time2)) * 17 / 100;
            dist3 <= to_integer(unsigned(time3)) * 17 / 100;
            dist4 <= to_integer(unsigned(time4)) * 17 / 100;

            -- Najdi nejmenší vzdálenost
            min_dist <= dist1;
            min_sensor <= 1;

            if dist2 < min_dist then
                min_dist <= dist2;
                min_sensor <= 2;
            end if;
            if dist3 < min_dist then
                min_dist <= dist3;
                min_sensor <= 3;
            end if;
            if dist4 < min_dist then
                min_dist <= dist4;
                min_sensor <= 4;
            end if;

            if min_dist < 100 then
                tens <= min_dist / 10;
                ones <= min_dist mod 10;
            else
                tens <= 10;
                ones <= 10;
            end if;
        end if;
    end process;

    -- Mapování číslic na 7-segmentový kód
    process(tens)
    begin
        case tens is
            when 0 => seg2 <= "1000000";
            when 1 => seg2 <= "1111001";
            when 2 => seg2 <= "0100100";
            when 3 => seg2 <= "0110000";
            when 4 => seg2 <= "0011001";
            when 5 => seg2 <= "0010010";
            when 6 => seg2 <= "0000010";
            when 7 => seg2 <= "1111000";
            when 8 => seg2 <= "0000000";
            when 9 => seg2 <= "0010000";
            when 10 => seg1 <= "0001001";
            when others => seg2 <= "0111111"; -- vypnuto
        end case;
    end process;

    process(ones)
    begin
        case ones is
            when 0 => seg1 <= "1000000";
            when 1 => seg1 <= "1111001";
            when 2 => seg1 <= "0100100";
            when 3 => seg1 <= "0110000";
            when 4 => seg1 <= "0011001";
            when 5 => seg1 <= "0010010";
            when 6 => seg1 <= "0000010";
            when 7 => seg1 <= "1111000";
            when 8 => seg1 <= "0000000";
            when 9 => seg1 <= "0010000";
            when 10 => seg1 <= "1111100";
            when others => seg1 <= "0111111";
        end case;
    end process;
        
    process(min_sensor)
    begin
        case min_sensor is
            when 1 => seg3 <= "1111100"; -- PP
            when 2 => seg3 <= "1110011"; -- PZ
            when 3 => seg3 <= "1100111"; -- LZ
            when 4 => seg3 <= "1011110"; -- LP
            when others => seg3 <= "1111111"; -- zhasnuto   
        end case;
    end process;

end Behavioral;