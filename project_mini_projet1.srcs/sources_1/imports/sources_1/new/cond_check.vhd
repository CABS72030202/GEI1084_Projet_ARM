----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/02/2025 10:58:40 PM
-- Design Name: Condition Check Logic
-- Module Name: cond_check - synth
-- Project Name: project_lab4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    This module implements the ARM condition code checking logic that determines
--    whether an instruction should be executed based on the current processor flags
--    and the condition field of the instruction. It evaluates the 4-bit condition
--    code against the NZCV flags to produce the CondEx output.
-- 
-- Dependencies: 
--    None
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Condition logic implementation completed
-- Additional Comments:
--
--    Input flags organization:
--    Flags_NZ: [1] = N (Negative), [0] = Z (Zero)
--    Flags_CV: [1] = C (Carry), [0] = V (Overflow)
--
--    Condition codes implemented:
--    0000: EQ (Equal)                      Z
--    0001: NE (Not Equal)                  \Z
--    0010: CS/HS (Carry Set/Unsigned HS)   C
--    0011: CC/LO (Carry Clear/Unsigned LO) \C
--    0100: MI (Minus/Negative)             N
--    0101: PL (Plus/Positive)              \N
--    0110: VS (Overflow Set)               V
--    0111: VC (Overflow Clear)             \V
--    1000: HI (Unsigned Higher)            \Z and C
--    1001: LS (Unsigned Lower/Same)        Z or \C
--    1010: GE (Signed Greater/Equal)       \(N xor V)
--    1011: LT (Signed Less Than)           N xor V
--    1100: GT (Signed Greater Than)        \Z and \(N xor V)
--    1101: LE (Signed Less/Equal)          Z or (N xor V)
--    1110: AL (Always)                     ignored
--    other:                                ignored
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cond_check is
    Port ( 
           Flags_NZ : in STD_LOGIC_VECTOR (1 downto 0);
           Flags_CV : in STD_LOGIC_VECTOR (1 downto 0);
           Cond     : in STD_LOGIC_VECTOR (3 downto 0);
           CondEx   : out STD_LOGIC
    );
end cond_check;

architecture synth of cond_check is

begin
    process(Flags_NZ, Flags_CV, Cond)
    begin
        case Cond is
            when "0000" =>      -- EQ
                CondEx <= Flags_NZ(0);
                
            when "0001" =>      -- NE
                CondEx <= not Flags_NZ(0);
                
            when "0010" =>      -- CS / HS
                CondEx <= Flags_CV(1);
                
            when "0011" =>      -- CC / LO
                CondEx <= not Flags_CV(1);
                
            when "0100" =>      -- MI
                CondEx <= Flags_NZ(1);
            
            when "0101" =>      -- PL
                CondEx <= not Flags_NZ(1);
            
            when "0110" =>      -- VS
                CondEx <= Flags_CV(0);
            
            when "0111" =>      -- VC
                CondEx <= not Flags_CV(0);
                
            when "1000" =>      -- HI
                CondEx <= (not Flags_NZ(0)) and Flags_CV(1);
            
            when "1001" =>      -- LS
                CondEx <= Flags_NZ(0) or (not Flags_CV(1));
            
            when "1010" =>      -- GE
                CondEx <= not (Flags_NZ(1) xor Flags_CV(0));
            
            when "1011" =>      -- LT
                CondEx <= Flags_NZ(1) xor Flags_CV(0);
            
            when "1100" =>      -- GT
                CondEx <= (not Flags_NZ(0)) and (not (Flags_NZ(1) xor Flags_CV(0)));
            
            when "1101" =>      -- LE
                CondEx <= Flags_NZ(0) or (Flags_NZ(1) xor Flags_CV(0));
            
            when "1110" =>      -- AL (or none)
                CondEx <= '1';
            
            when others =>
                CondEx <= '1';
        end case;
    end process;
end synth;
