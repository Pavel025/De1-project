# Topic 4: Ultrasound sensor(s) controller (HS-SR04)
Členové týmu

1. Martin Čontoš (zodpovědný za RGB LEDs)
2. Tadeáš Fojtách (zodpovědný za display)
3. Pavel Horský (zodpovědný za buzzer)
4. Karel Matoušek (zodpovědný za ultrasonic sensor)

## Abstract

## Demonstrační video
Krátká ukázka funkčnosti zařízení\
https://www.youtube.com/watch?v=OFte7NRmbUw
## Popis použitého hardwaru
### Nexys A7-50T
Nexys A7-50T je multifunkční FPGA deska

![Nexys A7-50T](nexys-a7-callout.png)

| Č. | Komponenta               | Č. | Komponenta                    | Č. | Komponenta                    |
|----|--------------------------|----|-------------------------------|----|-------------------------------|
| 1  | Napájecí konektor        | 11 | Reset FPGA konfigurace        | 21 | 7-segmentový displej (8 číslic) |
| 2  | Napájecí spínač          | 12 | CPU reset                     | 22 | Mikrofon                      |
| 3  | USB host konektor        | 13 | Pět tlačítek                  | 23 | Jumper (SD / USB)             |
| 4  | PIC24 port (výroba)      | 14 | Pmod porty                    | 24 | MicroSD slot                  |
| 5  | Ethernet konektor        | 15 | Teplotní senzor               | 25 | UART/JTAG USB port            |
| 6  | LED – programování FPGA dokončeno | 16 | JTAG port                     | 26 | Jumper napájení a baterie     |
| 7  | VGA konektor             | 17 | RGB LED                       | 27 | LED napájení                |
| 8  | Audio konektor           | 18 | Posuvné přepínače (16x)     | 28 | Xilinx Artix-7 FPGA           |
| 9  | Jumper program. režimu   | 19 | LED diody (16x)             | 29 | DDR2 paměť                    |
| 10 | Analogový Pmod port      | 20 | Testovací body napájení napájení       |    |                               |

### HC-SR04

Ultrazvukový měřič vzdálenosti v rozsahu 20 mm až 4 m.

![HC-SR04](HCSR04.png)

HC-SR04 je ovládán 10 us dlouhým spouštěcím impulzem, na který modul vyšle 8 zvukových impulzů a přepne výstup Echo do HI dokud nedostane odezvu, případně po překročení maximální vzdálenosti.

![HC-signals](HC-signals.png)

### Buzzer HW 508
HW 508 je modul řízený PWM signálem.

![buzzer](Buzzer.png)

### Level Shifter
Modul umožňující převod logické úrovně mezi 3,3V a 5V logikou

![alt text](image.png)

## Propojení s moduly
![alt text](image-2.png)


## Popis Softwaru a simulace

### LEDs

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


### 7-segment

### Bzučák
![buzzer-sim](Screenshot2025-05-08072512.png)
![alt text](image-3.png)


## Reference
https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual?srsltid=AfmBOoqcXasRu5ogYykyAvmd7k7G_U6G6f-TFImJu0mmkMR8xbL4xAxm

https://images.theengineeringprojects.com/image/webp/2018/10/Introduction-to-HC-SR04.jpg.webp?ssl=1

https://www.farnell.com/datasheets/3422740.pdf

https://microcontrollerslab.com/buzzer-module-interfacing-arduino-sound-code/

https://robu.in/wp-content/uploads/2016/05/i2c-logic-level-converter-4-channel-bi-directional-module.pdf

Výstupy
  - 7-seg
  - bzučák
  - LEDky/RGB

Main - senzor

Top level
--------------------------------------
7-seg
  - 3 segmentovky na vzdálenost
  - 1 na zobrazení aktivních senzorů

Bzučák
  - od 1 metru
  - po 0,2 m zvyšovat frekvenci?

![Snímek obrazovky](Snímek%20obrazovky%202025-04-10%20101607.png)
