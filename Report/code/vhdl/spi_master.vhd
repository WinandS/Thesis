library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SPI_Master is  -- SPI-Modus 0: CPOL=0, CPHA=0
    Generic ( Quarz_Taktfrequenz : integer   := 50000000;  -- Hertz 
              SPI_Taktfrequenz   : integer   :=  1000000;  -- Hertz 
              Laenge             : integer   :=   8       
             ); 
    Port ( TX_Data  : in  STD_LOGIC_VECTOR (Laenge-1 downto 0);
           RX_Data  : out STD_LOGIC_VECTOR (Laenge-1 downto 0);
           MOSI     : out STD_LOGIC;                           
           MISO     : in  STD_LOGIC;
           SCLK     : out STD_LOGIC;
           SS       : out STD_LOGIC;
           TX_Start : in  STD_LOGIC;
           TX_Done  : out STD_LOGIC;
           clk      : in  STD_LOGIC);
end SPI_Master;

architecture Behavioral of SPI_Master is
  signal   delay       : integer range 0 to (Quarz_Taktfrequenz/(2*SPI_Taktfrequenz));
  constant clock_delay : integer := (Quarz_Taktfrequenz/(2*SPI_Taktfrequenz))-1;
  type   spitx_states is (spi_stx,spi_txactive,spi_etx);
  signal spitxstate    : spitx_states := spi_stx;
  signal spiclk    : std_logic;
  signal spiclklast: std_logic;
  signal bitcounter    : integer range 0 to Laenge;
  signal tx_reg        : std_logic_vector(Laenge-1 downto 0) := (others=>'0');
  signal rx_reg        : std_logic_vector(Laenge-1 downto 0) := (others=>'0');
begin
   process begin 
     wait until rising_edge(CLK);
     if(delay>0) then delay <= delay-1;
     else             delay <= clock_delay;  
     end if;
     spiclklast <= spiclk;
     case spitxstate is
       when spi_stx =>
             SS          <= '1'; TX_Done     <= '0';
             bitcounter  <= Laenge; spiclk      <= '0'; 
             if(TX_Start = '1') then 
                spitxstate <= spi_txactive; 
                SS         <= '0';
                delay      <= clock_delay; 
             end if;
       when spi_txactive =>  
             if (delay=0) then
                spiclk <= not spiclk;
                if (bitcounter=0) then
                   spiclk     <= '0'; 
                   spitxstate <= spi_etx;
                end if;
                if(spiclk='1') then    
                   bitcounter <= bitcounter-1;  
                end if;  
             end if;
       when spi_etx =>
             SS      <= '1';
             TX_Done <= '1';
             if(TX_Start = '0') then 
               spitxstate <= spi_stx;
             end if;
     end case;
 end process;   
 
  process begin 
     wait until rising_edge(CLK);
     if (spiclk='1' and  spiclklast='0') then -- SPI-Modus 0
        rx_reg <= rx_reg(rx_reg'left-1 downto 0) & MISO;
     end if;
  end process;   
     
  process begin 
     wait until rising_edge(CLK);
     if (spitxstate=spi_stx) then   -- Zurucksetzen, wenn SS inaktiv
        tx_reg <= TX_Data;
     end if;
     if (spiclk='0' and  spiclklast='1') then -- SPI-Modus 0
        tx_reg <= tx_reg(tx_reg'left-1 downto 0) & tx_reg(0);
     end if;
  end process;   
  SCLK    <= spiclk; MOSI    <= tx_reg(tx_reg'left); RX_Data <= rx_reg;
end Behavioral;