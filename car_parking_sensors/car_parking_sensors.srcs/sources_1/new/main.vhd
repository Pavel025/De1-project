----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2025 09:51:36
-- Design Name: 
-- Module Name: main - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


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
           count : out STD_LOGIC_VECTOR(n_bits downto 0));
end main;

architecture Behavioral of main is
    signal sig_count : unsigned(n_bits downto 0) := (others => '0');
begin
    process (clk)
    begin   
        if rising_edge(clk) then 
            if echo = '1' then    
                sig_count <= sig_count + 1;
            else
                sig_count <= (others => '0');  -- Reset, když echo skončí
            end if;
        end if;
    end process;

    count <= std_logic_vector(sig_count);  -- Převod na std_logic_vector pro výstup
end Behavioral;
