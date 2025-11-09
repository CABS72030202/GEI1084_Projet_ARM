----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/02/2025 09:05:50 PM
-- Design Name: PC Logic
-- Module Name: pc_logic - synth
-- Project Name: project_lab4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    This module implements the program counter source selection logic for a processor.
--    The PCS output determines whether the next PC value comes from the regular increment
--    or from a branch/jump operation. The logic follows: PCS = ((Rd == 15) & RegW) | Branch
-- 
-- Dependencies: 
--    None
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Logic implementation completed
-- Additional Comments:
--
--    PCS = 1: Select branch/jump address
--    PCS = 0: Select PC + 4 (normal increment)
-- 
-- Reference : Harris, S. L., & Harris, D. M. (2015). Digital Design and Computer Architecture, 
--                  ARM Edition (pp. 399-400). Morgan Kaufmann. 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_logic is
    Port ( 
        Rd      : in STD_LOGIC_VECTOR (3 downto 0);
        Branch  : in STD_LOGIC;
        RegW    : in STD_LOGIC;
        PCS     : out STD_LOGIC
    );
end pc_logic;

architecture synth of pc_logic is
begin
    -- PCS = ((Rd == 15) & RegW) | Branch
    PCS <= '1' when (Rd = "1111" and RegW = '1') or Branch = '1' else '0';
end synth;
