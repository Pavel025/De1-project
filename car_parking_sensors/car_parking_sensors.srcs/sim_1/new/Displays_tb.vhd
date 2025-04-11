library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity obstacle_tb is
end obstacle_tb;

architecture behavior of obstacle_tb is

    -- Komponenta testované jednotky
    component obstacle_dir_disp
        Port (
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            time1   : in  STD_LOGIC_VECTOR(14 downto 0);
            time2   : in  STD_LOGIC_VECTOR(14 downto 0);
            time3   : in  STD_LOGIC_VECTOR(14 downto 0);
            time4   : in  STD_LOGIC_VECTOR(14 downto 0);
            seg1    : out STD_LOGIC_VECTOR(6 downto 0);
            seg2    : out STD_LOGIC_VECTOR(6 downto 0);
            seg3    : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Signály pro připojení
    signal clk     : STD_LOGIC := '0';
    signal reset   : STD_LOGIC := '0';
    signal time1   : STD_LOGIC_VECTOR(14 downto 0) := (others => '0');
    signal time2   : STD_LOGIC_VECTOR(14 downto 0) := (others => '0');
    signal time3   : STD_LOGIC_VECTOR(14 downto 0) := (others => '0');
    signal time4   : STD_LOGIC_VECTOR(14 downto 0) := (others => '0');
    signal seg1    : STD_LOGIC_VECTOR(6 downto 0);
    signal seg2    : STD_LOGIC_VECTOR(6 downto 0);
    signal seg3    : STD_LOGIC_VECTOR(6 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Připojení DUT (device under test)
    uut: obstacle_dir_disp
        Port map (
            clk     => clk,
            reset   => reset,
            time1   => time1,
            time2   => time2,
            time3   => time3,
            time4   => time4,
            seg1    => seg1,
            seg2    => seg2,
            seg3    => seg3
        );

    -- Generátor hodin
    clk_process :process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus
    stim_proc: process
    begin
        -- Reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Test 1: nejmenší je time1
        time1 <= std_logic_vector(to_unsigned(1000, 15)); -- 17 cm
        time2 <= std_logic_vector(to_unsigned(2000, 15)); -- 34 cm
        time3 <= std_logic_vector(to_unsigned(3000, 15)); -- 51 cm
        time4 <= std_logic_vector(to_unsigned(4000, 15)); -- 68 cm
        wait for 20 ns;

        -- Test 2: nejmenší je time4
        time1 <= std_logic_vector(to_unsigned(9000, 15)); -- 153 cm → nad 100 cm
        time2 <= std_logic_vector(to_unsigned(9000, 15));
        time3 <= std_logic_vector(to_unsigned(9000, 15));
        time4 <= std_logic_vector(to_unsigned(1000, 15)); -- 17 cm
        wait for 20 ns;

        -- Test 3: všechny > 100 cm → HI
        time1 <= std_logic_vector(to_unsigned(8000, 15)); -- ~136 cm
        time2 <= std_logic_vector(to_unsigned(8100, 15));
        time3 <= std_logic_vector(to_unsigned(8200, 15));
        time4 <= std_logic_vector(to_unsigned(8300, 15));
        wait for 20 ns;

        wait;
    end process;

end behavior;
