--mcdecoder
----------------------------------------------------------------------------------
-- Course: ELEC3342
-- Module Name: mucodec - Behavioral
-- Project Name: Template for Music Code Decoder for Homework 1
-- Created By: hso
--
-- Copyright (C) 2022 Hayden So
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mcdecoder is
    port (
        din     : IN std_logic_vector(2 downto 0);
        valid   : IN std_logic;
        clr     : IN std_logic;
        clk     : IN std_logic;
        dout    : OUT std_logic_vector(7 downto 0);
        dvalid  : OUT std_logic;
        error   : OUT std_logic);
end mcdecoder;

architecture Behavioral of mcdecoder is
    type state_type is (St_RESET, St_ERROR, LISTENING, B1,B2,B3,E1,E2,E3,L0,L1,L2,L3,L4,L5,L6);
    signal state, next_state : state_type := St_RESET;
    signal temp_dout:STD_LOGIC_VECTOR (7 downto 0);
    signal temp_dvalid, temp_error:STD_LOGIC;

    -- Define additional signal needed here as needed
begin
--    dout<="01010111";
--    process(clk) begin
--        if clr='1' then
--            dvalid<='1';
--        elsif rising_edge(clk) then
--            dvalid<='0';
--        end if;
--    end process;
    --Update register
    sync_process: process (clk, clr)
    begin
        if clr = '1' then
        -- Your code here
            state<=St_RESET;
            dvalid<='0';
        elsif rising_edge(clk) then
          -- Put your code here
            state<=next_state;
            dout<=temp_dout;
            dvalid<=temp_dvalid;
        end if;
    end process;

    --next state logic
    state_logic: process (state,din,valid)
    begin
        -- Complete the following:
        next_state <= state;
        if valid ='1' then
        case (state) is
            when St_RESET =>
                if din="000" then
                    next_state<= B1;
                else 
                    next_state<=St_ERROR;
                end if;
            when B1 =>
                if din="111" then
                    next_state<= B2;
                else 
                    next_state<=St_ERROR;
                end if;
             when B2 =>
                if din="000" then
                    next_state<= B3;
                else 
                    next_state<=St_ERROR;
                end if;
            when B3 =>
                if din="111" then
                    next_state<= LISTENING;
                else 
                    next_state<=St_ERROR;
                end if;
            when LISTENING =>
                case din is
                    when "111" =>
                        next_state<=E1;
                    when "001" =>
                        next_state<=L1;
                    when "010" =>
                        next_state<=L2;
                    when "011" =>
                        next_state<=L3;
                    when "100" =>
                        next_state<=L4;
                    when "101" =>
                        next_state<=L5;
                    when "110" =>
                        next_state<=L6;
                    when "000"=>
                        next_state<=L0;
                    when others =>
                        next_state<=St_ERROR;
                end case;
            when L0=>
                case din is
                    when "001"=>
                        next_state<=LISTENING;
                    when "010"=>
                        next_state<=LISTENING;
                    when "011"=>
                        next_state<=LISTENING;
                    when "100"=>
                        next_state<=LISTENING;
                    when "101"=>
                        next_state<=LISTENING;
                    when "110"=>
                        next_state<=LISTENING;
                    when others=>
                        next_state<=St_ERROR;
                end case;
            when L1 =>
                case din is
                    when "000"=>
                        next_state<=LISTENING;
                    when "010" =>
                        next_state<=LISTENING;
                    when "011" =>
                        next_state<=LISTENING;
                    when "100" =>
                        next_state<=LISTENING;
                    when "101" =>
                        next_state<=LISTENING;
                    when "110" =>
                        next_state<=LISTENING;
                    when others =>
                        next_state<=St_ERROR;
                end case;
            when L2 =>
                case din is
                    when "000"=>
                        next_state<=LISTENING;
                    when "001" =>
                         next_state<=LISTENING;
                    when "011" =>
                        next_state<=LISTENING;
                    when "100" =>
                        next_state<=LISTENING;
                    when "101" =>
                        next_state<=LISTENING;
                    when "110" =>
                        next_state<=LISTENING;
                    when others =>
                        next_state<=St_ERROR;
                end case;
            when L3 =>
                case din is
                    when "000"=>
                        next_state<=LISTENING;
                    when "001" =>
                         next_state<=LISTENING;
                    when "010" =>
                        next_state<=LISTENING;
                    when "100" =>
                        next_state<=LISTENING;
                    when "101" =>
                        next_state<=LISTENING;
                    when "110" =>
                        next_state<=LISTENING;
                    when others =>
                        next_state<=St_ERROR;
                end case;
            when L4 =>
                case din is
                    when "000"=>
                        next_state<=LISTENING;
                    when "001" =>
                         next_state<=LISTENING;
                    when "010" =>
                        next_state<=LISTENING;
                    when "011" =>
                        next_state<=LISTENING;
                    when "101" =>
                        next_state<=LISTENING;
                    when "110" =>
                        next_state<=LISTENING;
                    when others =>
                        next_state<=St_ERROR;
                end case;
            when L5 =>
                case din is
                    when "000"=>
                        next_state<=LISTENING;
                    when "001" =>
                         next_state<=LISTENING;
                    when "010" =>
                        next_state<=LISTENING;
                    when "011" =>
                        next_state<=LISTENING;
                    when "100" =>
                        next_state<=LISTENING;
                    when "110" =>
                        next_state<=LISTENING;
                    when others =>
                        next_state<=St_ERROR;
                end case;
            when L6 =>
                case din is
                    when "000"=>
                        next_state<=LISTENING;
                    when "001" =>
                         next_state<=LISTENING;
                    when "010" =>
                        next_state<=LISTENING;
                    when "011" =>
                        next_state<=LISTENING;
                    when "100" =>
                        next_state<=LISTENING;
                    when "101" =>
                        next_state<=LISTENING;
                    when others =>
                        next_state<=St_ERROR;
                end case;
            when E1 =>
               case din is
                 when "000"=>
                    next_state<=E2;
                when others =>
                    next_state<=St_ERROR;
               end case;
            when E2=>
             case din is
                when "111" =>
                    next_state<=E3;
                when others=> 
                    next_state<=St_ERROR;
             end case;
            when E3=>
                case din is
                    when "000"=>
                        next_state<=St_RESET;
                    when others =>
                        next_state<=St_ERROR;
                end case;
            when St_ERROR =>
                next_state<=St_RESET;
            when others =>
                next_state<=St_ERROR;
        end case;
        end if;
    end process;

    --Output logic
    output_logic: process (state,din, valid)
    begin
        if valid = '1' then
          case state is
            when L0=>
                case din is
                    when "001"=>
                        temp_dout<="00110001";
                        temp_dvalid<='1';
                    when "010"=>
                        temp_dout<="00110010";
                        temp_dvalid<='1';
                    when "011"=>
                        temp_dout<="00110011";
                        temp_dvalid<='1';
                    when "100"=>
                        temp_dout<="00110100";
                        temp_dvalid<='1';
                    when "101"=>
                        temp_dout<="00110101";
                        temp_dvalid<='1';
                    when "110"=>
                        temp_dout<="00110110";
                        temp_dvalid<='1';
                    when others=>
                end case;
            when L1=>
                case din is
                    when "000"=>
                        temp_dout<="00110111";
                        temp_dvalid<='1';                
                    when "010" =>
                        temp_dout<="01000010";
                        temp_dvalid<='1';
                    when "011" =>
                        temp_dout<="01000100";
                        temp_dvalid<='1';
                    when "100" =>
                        temp_dout<="01001000";
                        temp_dvalid<='1';
                    when "101" =>
                        temp_dout<="01001100";
                        temp_dvalid<='1';
                    when "110" =>
                        temp_dout<="01010010";
                        temp_dvalid<='1';
                    when others =>
                end case;
            when L2=>
                case din is
                    when "000"=>
                        temp_dout<="00111000";
                        temp_dvalid<='1';
                    when "001" =>
                        temp_dout<="01000001";
                        temp_dvalid<='1';
                    when "011" =>
                        temp_dout<="01000111";
                        temp_dvalid<='1';
                    when "100" =>
                        temp_dout<="01001011";
                        temp_dvalid<='1';
                    when "101" =>
                        temp_dout<="01010001";
                        temp_dvalid<='1';
                    when "110" =>
                        temp_dout<="01010110";
                        temp_dvalid<='1';
                    when others =>
                end case;
            when L3=>
                case din is
                    when "000"=>
                        temp_dout<="00111001";
                        temp_dvalid<='1';
                    when "001" =>
                        temp_dout<="01000011";
                        temp_dvalid<='1';
                    when "010" =>
                        temp_dout<="01000110";
                        temp_dvalid<='1';
                    when "100" =>
                        temp_dout<="01010000";
                        temp_dvalid<='1';
                    when "101" =>
                        temp_dout<="01010101";
                        temp_dvalid<='1';
                    when "110" =>
                        temp_dout<="01011010";
                        temp_dvalid<='1';
                    when others =>
                end case;
            when L4=>
                case din is
                    when "000"=>
                        temp_dout<="00110000";
                        temp_dvalid<='1';
                    when "001" =>
                        temp_dout<="01000101";
                        temp_dvalid<='1';
                    when "010" =>
                        temp_dout<="01001010";
                        temp_dvalid<='1';
                    when "011" =>
                        temp_dout<="01001111";
                        temp_dvalid<='1';
                    when "101" =>
                        temp_dout<="01011001";
                        temp_dvalid<='1';
                    when "110" =>
                        temp_dout<="00101110";
                        temp_dvalid<='1';
                    when others =>
                end case;
            when L5=>
                case din is
                    when "000"=>
                        temp_dout<="01011011";
                        temp_dvalid<='1';
                    when "001" =>
                        temp_dout<="01001001";
                        temp_dvalid<='1';
                    when "010" =>
                        temp_dout<="01001110";
                        temp_dvalid<='1';
                    when "011" =>
                        temp_dout<="01010100";
                        temp_dvalid<='1';
                    when "100" =>
                        temp_dout<="01011000";
                        temp_dvalid<='1';
                    when "110" =>
                        temp_dout<="00111111";
                        temp_dvalid<='1';
                    when others =>
                end case;
            when L6=>
                case din is
                    when "000" =>
                        temp_dout<="01011101";
                        temp_dvalid<='1';
                    when "001" =>
                        temp_dout<="01001101";
                        temp_dvalid<='1';
                    when "010" =>
                        temp_dout<="01010011";
                        temp_dvalid<='1';
                    when "011" =>
                        temp_dout<="01010111";
                        temp_dvalid<='1';
                    when "100" =>
                        temp_dout<="00100001";
                        temp_dvalid<='1';
                    when "101" =>
                        temp_dout<="00100000";
                        temp_dvalid<='1';
                    when others =>
                end case;
            when St_ERROR=>
               error<='1';
            when LISTENING=>
                temp_dvalid<='0';
            when others=>
--                temp_dout<="00000000";
                error<='0';
                temp_dvalid<='0';
          end case; 
       else
        temp_dvalid<='0';
        error<='0';
       end if;
    end process;
end Behavioral;