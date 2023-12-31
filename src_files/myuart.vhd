-- myuart
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity myuart is
    Port ( 
           din : in STD_LOGIC_VECTOR (7 downto 0);
           busy: out STD_LOGIC;
           wen : in STD_LOGIC;
           sout : out STD_LOGIC;
           clr : in STD_LOGIC;
           clk : in STD_LOGIC);
end myuart;

architecture rtl of myuart is
    signal countsup1,countsup2,sout_temp,busy_temp: std_logic;
    signal ctr1,ctr2: unsigned(7 downto 0);
    signal din_temp:std_logic_vector(7 downto 0);
begin
    process(clk,wen,countsup2)begin
        if countsup2='1' then
            din_temp<="00000000";
        elsif rising_edge(clk)then
            if wen ='1' then
                din_temp<=din;
            end if;
        end if;
    end process;
    --counter 1
    process(clk,countsup2,countsup1,clr)begin
        if countsup2='1' or countsup1 = '1' or clr='1' then
            ctr1<= (others=>'0');
        elsif rising_edge(clk) then
            ctr1<=ctr1+1;
        end if;
    end process;
    
    process(clk) begin
    if rising_edge(clk) then
        if ctr1 =8 then
            countsup1<='1';
        else
            countsup1<='0';
        end if;
    end if;
    end process;
    
    --counter 2
    process(clk,wen,countsup1,clr)begin
        if clr = '1' then
            ctr2<=to_unsigned(10,8);
        elsif wen = '1' then
            ctr2<=(others=>'0');
        elsif rising_edge(clk) then
            case countsup1 is
                when '0'=>
                    ctr2<=ctr2+0;
                when others=>
                    ctr2<=ctr2+1;
            end case; 
        end if;
    end process;
    countsup2<='1' when (ctr2=10) else '0';
    
    --sout processes
    process(ctr2)begin
        if ctr2 = 0 then
            sout_temp<='0';
        elsif ctr2=9 or ctr2=10 then
            sout_temp<='1';
        elsif ctr2<9 then
            sout_temp<=din_temp(to_integer(ctr2) - 1);
        end if;
    end process;
    
    process(clk,clr) begin
        if clr = '1' then
            sout<='1';
        elsif rising_edge(clk) then
            sout<=sout_temp;
        end if;
    end process;
    
    --busy processes
    process(clk,clr)begin
        if clr='1' then
            busy<='0';
        elsif rising_edge(clk) then
            busy<=not countsup2;
        end if;
    end process;
    
end rtl;