----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 10/05/2025 03:36:38 PM
-- Design Name: 
-- Module Name: extend - synth
-- Project Name: project_lab2
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    Extends 24-bit immediate values to 32 bits based on control signal.
--    Supports three extension modes for different ARM instruction formats.
-- 
-- Dependencies: IEEE STD_LOGIC_1164
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--    Assumes immediate values are right-aligned in the 24-bit input field
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity extend is
    generic (
        N: integer := 24;   -- Input width
        M: integer := 32    -- Output width
    );
    Port ( 
        imm_src : in STD_LOGIC_VECTOR(1 downto 0);      -- Extension mode control
        input   : in STD_LOGIC_VECTOR(N-1 downto 0);    -- Input
        output  : out STD_LOGIC_VECTOR(M-1 downto 0)    -- Extended output
    );
end extend;

architecture synth of extend is
begin
    process(imm_src, input)
    begin
        case imm_src is
            when "00" =>    -- Imm8: 24 zeros + 8 LSB
                output <= x"000000" & input(7 downto 0);
            when "01" =>    -- Imm12: 20 zeros + 12 LSB  
                output <= x"00000" & input(11 downto 0);
            when "10" =>    -- Imm24: 8 zeros + 24 LSB
                output <= x"00" & input;
            when others =>  -- Default case (Imm24)
                output <= x"00" & input;
        end case;
    end process;
end synth;
