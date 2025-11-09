----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 09/28/2025 01:12:51 PM
-- Design Name: 
-- Module Name: mux2 - Synth
-- Project Name: project_lab1
-- Target Devices: 
-- Tool Versions: 
-- Description: N-bit 2-to-1 multiplexer with generic bus width.
--              The multiplexer selects one of two N-bit inputs based on a 
--              single select signal. Generic parameter N defines the bus width.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Updated to use generic N for vector width
-- Additional Comments:
-- 
-- Truth Table:
-- s    | Output
-- -----|-------
--  0   |   d0
--  1   |   d1
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
    generic (N : integer := 32);
    Port ( 
        d0,d1 : in STD_LOGIC_VECTOR(N-1 downto 0);  -- N-bit input vectors
        s     : in STD_LOGIC;                       -- Select line
        y     : out STD_LOGIC_VECTOR(N-1 downto 0)  -- N-bit output vector
    );
end entity mux2;

architecture synth of mux2 is
begin
    y <= d1 when s = '1' else d0;
end architecture synth;