----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 09/28/2025 01:12:51 PM
-- Design Name: 
-- Module Name: mux4 - Structural
-- Project Name: project_lab1
-- Target Devices: 
-- Tool Versions: 
-- Description: N-bit 4-to-1 multiplexer built using three 2-to-1 mux components.
--              The multiplexer selects one of four N-bit inputs based on a 2-bit
--              select signal. Generic parameter N defines the bus width.
-- 
-- Dependencies: mux2.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Updated to use generic N for vector width
-- Additional Comments:
-- 
-- Truth Table:
-- s(1) s(0) | Output
-- ----------|-------
--   0    0  |   d0
--   0    1  |   d1
--   1    0  |   d2
--   1    1  |   d3
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4 is
    generic (N : integer := 32);
    Port ( 
        d0,d1,d2,d3 : in STD_LOGIC_VECTOR(N-1 downto 0);  -- N-bit input vectors
        s           : in STD_LOGIC_VECTOR(1 downto 0);    -- 2-bit select line
        y           : out STD_LOGIC_VECTOR(N-1 downto 0)  -- N-bit output vector
    );
end;

architecture struct of mux4 is
    component mux2 is
        generic (N : integer := 32);
        Port ( 
            d0,d1   : in STD_LOGIC_VECTOR(N-1 downto 0);
            s       : in STD_LOGIC;
            y       : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    signal mux_a_out, mux_b_out : STD_LOGIC_VECTOR(N-1 downto 0);
begin
    MUX_A: mux2 
        generic map (N => N)
        port map (d0, d1, s(0), mux_a_out);
        
    MUX_B: mux2 
        generic map (N => N)
        port map (d2, d3, s(0), mux_b_out);
    
    MUX4 : mux2 
        generic map (N => N)
        port map (mux_a_out, mux_b_out, s(1), y);
end;