----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/15/2025 16:23:03 PM
-- Design Name: Shifter Unit
-- Module Name: shifter - synth
-- Project Name: project_mini_projet1
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    Shifter unit for ARM processor datapath.
--    Implements barrel shifter supporting LSL, LSR, ASR, and ROR operations.
--    Takes register value and shift amount/type from instruction fields.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Complete shifter implementation with all shift types
-- Additional Comments:
--    Shift types:
--    00: LSL - Logical Shift Left
--    01: LSR - Logical Shift Right  
--    10: ASR - Arithmetic Shift Right
--    11: ROR - Rotate Right
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shifter is
    generic (N : integer := 32);
    Port (
        input_data   : in STD_LOGIC_VECTOR (N-1 downto 0);
        shift_amount : in STD_LOGIC_VECTOR (4 downto 0);
        shift_type   : in STD_LOGIC_VECTOR (1 downto 0);
        output_data  : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end shifter;

architecture synth of shifter is
    signal shift_val : integer range 0 to 31;
begin
    shift_val <= to_integer(unsigned(shift_amount));
    
    process(input_data, shift_val, shift_type)
        variable temp_result : STD_LOGIC_VECTOR(N-1 downto 0);
    begin
        case shift_type is
            when "00" => -- LSL: Logical Shift Left
                if shift_val = 0 then
                    temp_result := input_data;
                else
                    temp_result := std_logic_vector(shift_left(unsigned(input_data), shift_val));
                end if;
                
            when "01" => -- LSR: Logical Shift Right
                if shift_val = 0 then
                    temp_result := input_data;
                else
                    temp_result := std_logic_vector(shift_right(unsigned(input_data), shift_val));
                end if;
                
            when "10" => -- ASR: Arithmetic Shift Right
                if shift_val = 0 then
                    temp_result := input_data;
                else
                    temp_result := std_logic_vector(shift_right(signed(input_data), shift_val));
                end if;
                
            when "11" => -- ROR: Rotate Right
                if shift_val = 0 then
                    temp_result := input_data;
                else
                    temp_result := std_logic_vector(rotate_right(unsigned(input_data), shift_val));
                end if;
                
            when others =>
                temp_result := input_data;
        end case;
        
        output_data <= temp_result;
    end process;
end synth;