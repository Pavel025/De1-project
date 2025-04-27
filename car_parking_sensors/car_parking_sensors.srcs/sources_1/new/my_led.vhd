library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity my_led is
    Port (
        clk       : in STD_LOGIC;
        distance  : in STD_LOGIC_VECTOR(14 downto 0);   
        LED16_R   : out STD_LOGIC_VECTOR(7 downto 0);   
        LED16_G   : out STD_LOGIC_VECTOR(7 downto 0);
        LED16_B   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end my_led;

architecture Behavioral of my_led is
    signal distance_sig : unsigned(14 downto 0);
begin

    distance_sig <= unsigned(distance);

    process(clk)
    begin
        if rising_edge(clk) then 
            if distance_sig > 8000 then
                LED16_R <= x"00"; 
                LED16_G <= x"FF";
                LED16_B <= x"00";
            elsif distance_sig > 7000 then
                LED16_R <= x"A0";  
                LED16_G <= x"FF";
                LED16_B <= x"00";
            elsif distance_sig > 6000 then
                LED16_R <= x"FF"; 
                LED16_G <= x"FF";
                LED16_B <= x"00";
            elsif distance_sig > 5000 then
                LED16_R <= x"FF";  
                LED16_G <= x"B4";
                LED16_B <= x"00";
            elsif distance_sig > 4000 then
                LED16_R <= x"FF"; 
                LED16_G <= x"68";
                LED16_B <= x"00";
            else
                LED16_R <= x"FF";
                LED16_G <= x"00";
                LED16_B <= x"00";
            end if;
        end if;
    end process;
end Behavioral;