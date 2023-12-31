-- NEW Synthesizable symb_det
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity symb_det is
    Port (  clk: in STD_LOGIC; -- input clock 96kHz
            clr: in STD_LOGIC; -- input synchronized reset
            adc_data: in STD_LOGIC_VECTOR(11 DOWNTO 0); -- input 12-bit ADC data
            symbol_valid: out STD_LOGIC;
            symbol_out: out STD_LOGIC_VECTOR(2 DOWNTO 0) -- output 3-bit detection symbol
            );
end symb_det;

architecture Behavioral of symb_det is
    signal countsup1,crossed,start_count,silent,start_scanning,toggle,countsup3:std_logic;
    signal ctr1,ctr2,ctr2_temp,ctr3:unsigned(12 downto 0);
    signal val,next_val:std_logic_vector(11 downto 0);
    signal symb_out_temp:std_logic_vector(2 downto 0);
    signal symb_valid_temp:std_logic;
    signal adc_data_temp:std_logic_vector(11 downto 0);
begin
    adc_data_temp<=adc_data-"100000000000";
    --Processes for checking whether ADC data is big enough to start the circuit (A.K.A. The setup)
    --Checks if adc_data pass a certain treshold
    process(adc_data)begin
        if unsigned(adc_data_temp)>4 then
            start_scanning<='1';
        else
            start_scanning<='0';
        end if;
    end process;
    
    toggle<=start_scanning and silent;
    
    --TFF for when adc_data does become big 
    process(toggle,clk,clr)begin
    if clr = '1' then
        silent<='1';
    elsif rising_edge(clk) then
        if toggle = '1' then
            silent<=not silent;
        end if;
    end if;
    end process;
    
    --counter1 processes
    --The counter
    process(clk,silent,countsup1)begin
        if silent='1' or countsup1='1' then
            ctr1<=(others=>'0');
        elsif rising_edge(clk) then
            ctr1<=ctr1+1;
        end if;
    end process;
    
    --countsup1
    process(ctr1,clk)begin
        if rising_edge(clk) then
            if ctr1=6000 then
                countsup1 <='1';
            else
                countsup1<='0';
            end if;
        end if;
    end process;
    
    --crossing processes
    --Delay line
    process(clk,adc_data_temp)begin
        if rising_edge(clk) then
            val<=next_val;
            next_val<=adc_data_temp;
        end if;
    end process;
    
    --cross checking
    crossed<='1' when(val(11)='0' and next_val(11)='1') else '0';
    
    
    --ctr3 process
    process(clk,crossed,countsup3,countsup1,silent)begin
        if countsup1 = '1' or silent='1' then
            ctr3<=(others=>'0');
        elsif rising_edge(clk) then
            if countsup3 = '0' and crossed='1' then
                ctr3 <= ctr3+1;
            else
                ctr3<=ctr3+0;
            end if;
        end if;
    end process;
    countsup3<='1' when(ctr3>1) else '0';
    start_count<='1' when(ctr3=1) else '0';
    
    
    --ctr2 processes
    --ctr2 process
    process(clk,countsup1,silent,start_count)begin
        if(countsup1='1' or silent='1')then
            ctr2<=(others=>'0');
        elsif rising_edge(clk) then
            if start_count='1' then
                ctr2<=ctr2+1;
            else
                ctr2<=ctr2+0;
            end if;
        end if;
    end process;
    
    --ctr2_temp process (for output)
    process(clk)begin
        if rising_edge(clk) then
            ctr2_temp<=ctr2;
        end if;
    end process;
    
    
    --output processes
    --symbol_out process
    process(ctr2_temp,countsup1)begin
        if countsup1 = '1' then
            if ctr2_temp>=165 and ctr2<=203 then
                symb_out_temp<="111";
            elsif ctr2_temp<165 and ctr2_temp>=135 then
                symb_out_temp<="110";
            elsif ctr2_temp<135 and ctr2_temp>=111 then
                symb_out_temp<="101";
            elsif ctr2_temp<111 and ctr2_temp>=90 then
                symb_out_temp<="100";
            elsif ctr2_temp<90 and ctr2_temp>=76 then
                symb_out_temp<="011";
            elsif ctr2_temp<76 and ctr2_temp>=62 then
                symb_out_temp<="010";
            elsif ctr2_temp<62 and ctr2_temp>=51 then
                symb_out_temp<="001";
            elsif ctr2_temp<51 and ctr2_temp>=41 then
                symb_out_temp<="000";
            end if;
        end if;
    end process;
    
    process(symb_out_temp,clk,silent)begin
        if silent='1' then
            symbol_out<="000";
        elsif rising_edge(clk) then
            if countsup1='1' then
                symbol_out<=symb_out_temp;
            end if;
        end if;
    end process;
    
    --symbol_valid processes
    process(countsup1,clk,silent)begin
        if silent='1' then
            symbol_valid<='0';
        elsif rising_edge(clk) then
            symbol_valid<=countsup1;
        end if;
    end process;

end Behavioral;