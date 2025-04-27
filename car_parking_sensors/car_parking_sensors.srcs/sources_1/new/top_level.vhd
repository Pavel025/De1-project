library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
    Port (
        CLK100MHZ : in STD_LOGIC;
        ECHO1     : in STD_LOGIC;
        ECHO2     : in STD_LOGIC;
        ECHO3     : in STD_LOGIC;
        ECHO4     : in STD_LOGIC;
        TRIG1     : out STD_LOGIC;
        TRIG2     : out STD_LOGIC;
        TRIG3     : out STD_LOGIC;
        TRIG4     : out STD_LOGIC;
        
        BUZZER    : out STD_LOGIC;
        
        LED_R     : out STD_LOGIC_VECTOR(7 downto 0);
        LED_G     : out STD_LOGIC_VECTOR(7 downto 0);
        LED_B     : out STD_LOGIC_VECTOR(7 downto 0);
        
        CA        : out   std_logic;                     
        CB        : out   std_logic;                     
        CC        : out   std_logic;                     
        CD        : out   std_logic;                     
        CE        : out   std_logic;                     
        CF        : out   std_logic;                     
        CG        : out   std_logic;                     
        DP        : out   std_logic;                     
        AN        : out   std_logic_vector(7 downto 0)
        );
    
end top_level;

architecture Behavioral of top_level is

    component main is
        generic(
            n_bits : integer := 14
        );
        Port ( clk    : in STD_LOGIC;
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
               count4 : out STD_LOGIC_VECTOR(n_bits downto 0)
         );
    end component;

    component my_buzzer is
        Port (
            clk   : in  STD_LOGIC;
            dist  : in  STD_LOGIC_VECTOR(14 downto 0);  -- 32 767 ~ 4 m
            beep  : out STD_LOGIC
        );
    end component;
    
    component my_led is
        Port (
            clk      : in STD_LOGIC;
            distance : in STD_LOGIC_VECTOR(14 downto 0);   -- cm distance 
            LED16_R  : out STD_LOGIC_VECTOR(7 downto 0);   -- red 
            LED16_G  : out STD_LOGIC_VECTOR(7 downto 0);   -- green 
            LED16_B  : out STD_LOGIC_VECTOR(7 downto 0)    -- blue 
        );
    end component;
    
    component seg_disp is
        Port (
            clk       : in  STD_LOGIC;
            time1     : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 1
            time2     : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 2
            time3     : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 3
            time4     : in  STD_LOGIC_VECTOR(14 downto 0);  -- čas od senzoru 4
            seg       : out STD_LOGIC_VECTOR(6 downto 0);   -- jednotky
            min_dist  : out STD_LOGIC_VECTOR(8 downto 0);
            multiplex : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    signal sig_tmp1 : STD_LOGIC_VECTOR(14 downto 0);
    signal sig_tmp2 : STD_LOGIC_VECTOR(14 downto 0);
    signal sig_tmp3 : STD_LOGIC_VECTOR(14 downto 0);
    signal sig_tmp4 : STD_LOGIC_VECTOR(14 downto 0);
    
    signal dist_tmp : STD_LOGIC_VECTOR(8 downto 0);

begin
    
    main0 : component main
        generic map (
            n_bits => 14
        )
        port map ( 
            clk   => CLK100MHZ,
            echo1  => ECHO1,
            echo2  => ECHO2,
            echo3  => ECHO3,
            echo4  => ECHO4,
            trig1  => TRIG1,
            trig2  => TRIG2,
            trig3  => TRIG3,
            trig4  => TRIG4,
            count1 => sig_tmp1,
            count2 => sig_tmp2,
            count3 => sig_tmp3,
            count4 => sig_tmp4
         );
     
    buzz : component my_buzzer
         port map (
            clk   => CLK100MHZ,
            dist  => dist_tmp,
            beep  => BUZZER
         );
     
    led : component my_led
         port map (
            clk => CLK100MHZ,
            distance => dist_tmp,   -- cm distance 
            LED16_R => LED_R,   -- red 
            LED16_G => LED_G,   -- green 
            LED16_B => LED_B    -- blue 
            );
            
    display : component seg_disp
        port map (
            clk => CLK100MHZ,
            time1 => sig_tmp1,
            time2 => sig_tmp2,
            time3 => sig_tmp3,
            time4 => sig_tmp4,
            seg(6) => CA,
            seg(5) => CB,
            seg(4) => CC,
            seg(3) => CD,
            seg(2) => CE,
            seg(1) => CF,
            seg(0) => CG,
            min_dist => dist_tmp,
            multiplex => AN
        );
        
        DP <= '1';
        
end Behavioral;