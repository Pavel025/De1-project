library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seg_disp is
    Port (
        clk         : in  STD_LOGIC;
        time1       : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 1
        time2       : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 2
        time3       : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 3
        time4       : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 4
        seg         : out STD_LOGIC_VECTOR(6 downto 0);   -- číslo, které se zobrazí na displeji
        min_dist    : out STD_LOGIC_VECTOR(8 downto 0);
        multiplex   : out STD_LOGIC_VECTOR(7 downto 0)    -- displej, který se rozsvítí
    );
end seg_disp;

architecture Behavioral of seg_disp is
    signal dist1, dist2, dist3, dist4 : integer := 0;
    signal tens, ones                 : integer := 0;
    signal min_sensor                 : integer := 0;
    signal seg1, seg2, seg3           : unsigned(6 downto 0) := (others => '0');
    
    signal clk_1kHz_counter           : unsigned(16 downto 0) := (others => '0');
    signal local_multiplex            : unsigned(7 downto 0) := (others => '0');
    signal process_num                : unsigned(1 downto 0) := b"01";

begin

process(clk)
    variable d1, d2, d3, d4 : integer;
    variable local_min      : integer;
    variable local_sensor   : integer;
begin
    if rising_edge(clk) then
        d1 := to_integer(unsigned(time1)) * 343 / 20000;
        d2 := to_integer(unsigned(time2)) * 343 / 20000;
        d3 := to_integer(unsigned(time3)) * 343 / 20000;
        d4 := to_integer(unsigned(time4)) * 343 / 20000;
        dist1 <= d1;
        dist2 <= d2;
        dist3 <= d3;
        dist4 <= d4;

        -- Lokální porovnání mimo signály
        local_min := d1;
        local_sensor := 1;

        if d2 < local_min then
            local_min := d2;
            local_sensor := 2;
        end if;
        if d3 < local_min then
            local_min := d3;
            local_sensor := 3;
        end if;
        if d4 < local_min then
            local_min := d4;
            local_sensor := 4;
        end if;

        min_dist <= std_logic_vector(to_unsigned(local_min, min_dist'length));
        min_sensor <= local_sensor;

        -- Převod na číslice
        if local_min < 100 then
            tens <= local_min / 10;
            ones <= local_min mod 10;
        else
            tens <= 10;
            ones <= 10;
        end if;
        
        -- Multiplexování
        if clk_1KHz_counter = 999999 then
            if process_num = 1 then
                process_num <= b"10";
                clk_1kHz_counter <= (others => '0');
                local_multiplex <= b"1111_1110";    -- změnit podle dohody!!!!!!!!!!!!!!!!!!!!!!!!!!
            elsif process_num = 2 then
                process_num <= b"11";
                clk_1kHz_counter <= (others => '0');
                local_multiplex <= b"1111_1101";     -- změnit podle dohody!!!!!!!!!!!!!!!!!!!!!!!!!!
            elsif process_num = 3 then
                process_num <= b"01";
                clk_1kHz_counter <= (others => '0');
                local_multiplex <= b"1111_0111";     -- změnit podle dohody!!!!!!!!!!!!!!!!!!!!!!!!!!    
            end if;
        else
            clk_1KHz_counter <= clk_1KHz_counter + 1;
        end if;
        multiplex <= std_logic_vector(local_multiplex);
    end if;
end process;


    -- Mapování číslic na 7-segmentový kód
    process(ones)       -- process_num 1
    begin
        if process_num = 1 then
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
                when 10 => seg1 <= "1111001";
                when others => seg1 <= "0111111";
            end case;
            seg <= std_logic_vector(seg1);
        end if;
    end process;
    
    process(tens)       -- process_num 2
    begin
        if process_num = 2 then
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
                when 10 => seg2 <= "0001001";
                when others => seg2 <= "0111111"; -- vypnuto
            end case;
            seg <= std_logic_vector(seg2);
        end if;
    end process;
        
    process(min_sensor)  -- process_num 3
    begin
        if process_num = 3 then
            case min_sensor is
                when 1 => seg3 <= "1111100"; -- PP
                when 2 => seg3 <= "1110011"; -- PZ
                when 3 => seg3 <= "1100111"; -- LZ
                when 4 => seg3 <= "1011110"; -- LP
                when others => seg3 <= "0111111"; -- vypnuto   
            end case;
            seg <= std_logic_vector(seg3);
        end if;
    end process;

end Behavioral;