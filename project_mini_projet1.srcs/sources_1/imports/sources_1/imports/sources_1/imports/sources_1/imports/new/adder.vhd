----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 09/28/2025 01:12:51 PM
-- Design Name: 
-- Module Name: adder - Synth
-- Project Name: project_lab1
-- Target Devices: 
-- Tool Versions: 
-- Description: N-bit binary adder with carry input and carry output.
--              Performs the operation: result = a + b + cin
--              Generic parameter N defines the operand width.
--              Uses STD_LOGIC_UNSIGNED for arithmetic operations.
-- 
-- Dependencies: IEEE.STD_LOGIC_UNSIGNED
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
-- Operation:
-- Inputs:  a, b (N-bit), cin (carry in)
-- Outputs: s (N-bit sum), cout (carry out)
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder is
    generic (N : integer := 32);
    Port ( 
        a,b  : in STD_LOGIC_VECTOR(N-1 downto 0); 
        cin  : in STD_LOGIC;
        s    : out STD_LOGIC_VECTOR(N-1 downto 0);
        cout : out STD_LOGIC
    );
end;

architecture synth of adder is
    signal result : STD_LOGIC_VECTOR(N downto 0);
begin
    result  <= ('0' & a) + ('0' & b) + cin;
    s       <= result(N-1 downto 0);
    cout    <= result(N);
end;
