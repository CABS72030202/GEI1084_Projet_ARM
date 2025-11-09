----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/03/2025 10:19:57 AM
-- Design Name: Instruction Memory
-- Module Name: instr_memory - synth
-- Project Name: project_lab4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    This module implements the instruction memory for the ARM processor.
--    It stores the program instructions in a read-only memory array and
--    provides instruction fetch capability. The memory is word-addressable
--    and uses the PC value to retrieve the corresponding instruction.
-- 
-- Dependencies: 
--    None
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Instruction memory initialization completed
-- Additional Comments:
--    The memory is organized as a 32-bit wide array with 32 locations.
--    Instructions are stored in little-endian format as 32-bit words.
--    Address decoding uses bits [6:2] of the input address (A) to support
--    word-aligned addressing (PC[6:2] selects the instruction word).
--    
--    Memory initialization contains a sample program with 20 instructions
--    including data processing, memory access, and branch operations.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_memory is
    generic(M : integer := 32);
    Port ( 
        A   : in STD_LOGIC_VECTOR (M-1 downto 0);
        Rd  : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end instr_memory;

architecture synth of instr_memory is
    type mem_array is array (M-1 downto 0) of STD_LOGIC_VECTOR(M-1 downto 0);
    signal mem : mem_array := (others => (others => '0'));  -- Initialize to 0
begin
    -- Fill instruction memory
    mem(0)  <= "11100000010000000000000000000000";
    mem(1)  <= "11100010100000000010000000000101";
    mem(2)  <= "11100010100000000011000000001100";
    mem(3)  <= "11100010010000110111000000001001";
    mem(4)  <= "11100001100001110100000000000010";
    mem(5)  <= "11100000000000110101000000000100";
    mem(6)  <= "11100000100001010101000000000100";
    mem(7)  <= "11100000010101011000000000000111";
    mem(8)  <= "11100000010100111000000000000100";
    mem(9)  <= "11100010100000000101000000000000";
    mem(10) <= "11100000010101111000000000000010";
    mem(11) <= "10110010100001010111000000000001";
    mem(12) <= "11100000010001110111000000000010";
    mem(13) <= "11100101100000110111000001010100";
    mem(14) <= "11100101100100000010000001100000";
    mem(15) <= "11100000100010000101000000000000";
    mem(16) <= "11100010100000000010000000001110";
    mem(17) <= "11100010100000000010000000001101";
    mem(18) <= "11100010100000000010000000001010";
    mem(19) <= "11100101100000000010000001100100";
    
    -- Output (PC[6:2])nth instruction
    Rd <= mem(TO_INTEGER(unsigned(A(6 downto 2))));
end synth;
