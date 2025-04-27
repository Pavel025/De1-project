----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2025 09:31:28
-- Design Name: 
-- Module Name: top_level - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
    Port (
        CLK100MHZ : in STD_LOGIC;
        ECHO : in STD_LOGIC;
        TRIG : out STD_LOGIC;
        BUZZER : out STD_LOGIC
--        LED_R : out STD_LOGIC_VECTOR(7 downto 0);
--        LED_G : out STD_LOGIC_VECTOR(7 downto 0);
--        LED_B : out STD_LOGIC_VECTOR(7 downto 0)
        );
    
end top_level;

architecture Behavioral of top_level is

    component main is
    generic(
        n_bits : integer := 14
    );
    Port ( clk   : in STD_LOGIC;
           echo  : in STD_LOGIC;
           trig  : out STD_LOGIC;
           count : out STD_LOGIC_VECTOR(n_bits downto 0);
           clk_1MHz_out : out STD_LOGIC -- Jen pro simulaci
     );
    end component;

    component my_buzzer is
    Port (
        clk   : in  std_logic;
        dist  : in  STD_LOGIC_VECTOR(14 downto 0);  -- 32 767 ~ 4 m
        beep  : out STD_LOGIC
    );
    end component;
    
--    component my_led is
--    Port (
--        clk :       in STD_LOGIC;
--        distance :  in STD_LOGIC_VECTOR(14 downto 0);   -- cm distance 
--        LED16_R :   out STD_LOGIC_VECTOR(7 downto 0);   -- red 
--        LED16_G :   out STD_LOGIC_VECTOR(7 downto 0);   -- green 
--        LED16_B :   out STD_LOGIC_VECTOR(7 downto 0)    -- blue 
--    );
--    end component;
    
    signal sig_tmp : std_logic_vector(14 downto 0);

begin
    
    main0 : component main
    generic map (
        n_bits => 14
    )
    port map ( 
        clk   => CLK100MHZ,
        echo  => ECHO,
        trig  => TRIG,
        count => sig_tmp,
        clk_1MHz_out => open
     );
     
     buzz : component my_buzzer
     port map (
        clk   => CLK100MHZ,
        dist  => sig_tmp,
        beep  => BUZZER
     );
     
--     led : component my_led
--     port map (
--        clk => CLK100MHZ,
--        distance => sig_tmp,   -- cm distance 
--        LED16_R => LED_R,   -- red 
--        LED16_G => LED_G,   -- green 
--        LED16_B => LED_B    -- blue 
--        );
        
end Behavioral;
