RGB led 

názorně a logicky svítí barvou, která reprezentuje naši vzdálenost od překážky

když jsme blízko (tzn. 0cm - 25cm svítí červeně)

po 25cm dostupech se odstín zabarvuje do zelena a od 1m svítí čistě zeleně = překážka je dost daleko 



Vstupy

    - clk     : in  STD_LOGIC;   -- Hodinový signál (100 MHz)
    - my_dist : in  STD_LOGIC_VECTOR(8 downto 0);  -- Vzdálenost v cm (9 bitů)

    

Výstupy

    - red     : out STD_LOGIC; 
    - green   : out STD_LOGIC;
    - blue    : out STD_LOGIC


Pomocné signály

      signal pwm_counter : unsigned(7 downto 0) := (others => '0');
Signály pro duty cycle (intenzita) každého kanálu

      signal red_duty   : unsigned(7 downto 0) := (others => '0');
      signal green_duty : unsigned(7 downto 0) := (others => '0');
      signal blue_duty  : unsigned(7 downto 0) := (others => '0');
  
  -- PWM counter je 8 bitové číslo, počítá od 0 do 255, + 1 se přidá s další rising edge clk 
  -- Frekvence PWM = 100 MHz / 256 = 390 kHz
  
    if rising_edge(clk) then
      pwm_counter <= pwm_counter + 1; -- Inkrementace čítače (0-255)
    end if;
  
  RGB led tedy bliká 390 tisíckrát během sekundy, je to více něž dost na to, aby jsme blikání okem nezaznamenali

  
  Upravuji PWM šířku, kde nastavuji číslo od 0 do 255, = Duty cycle


Simulace 

![image](https://github.com/user-attachments/assets/d8458fd2-30b7-440d-9de1-f2cccd60f65a)

RGB na desce 

![RGB na desce](https://github.com/user-attachments/assets/4120faa5-01e3-46eb-9500-818254c9b527)



  
