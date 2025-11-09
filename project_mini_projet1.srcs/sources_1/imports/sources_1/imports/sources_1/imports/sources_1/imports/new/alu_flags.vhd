----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 09/28/2025 03:09:56 PM
-- Design Name: 
-- Module Name: alu_flags - Structural
-- Project Name: project_lab1
-- Target Devices: 
-- Tool Versions: 
-- Description: N-bit Arithmetic Logic Unit with Status Flags (NZCV).
--              Performs ADD, SUBTRACT, AND, and OR operations with full flag support.
--              Flags: Negative (N), Zero (Z), Carry (C), Overflow (V)
-- 
-- Dependencies: mux2.vhd, mux4.vhd, adder.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
-- ALU Control Truth Table:
-- ALUControl | Operation | Description
-- -----------|-----------|------------
--     00     |   ADD     | A + B
--     01     |   SUBTRACT| A - B (A + ~B + 1)
--     10     |   AND     | A AND B
--     11     |   OR      | A OR B
-- 
-- Flag Definitions:
-- N (Negative): result(31) - MSB of result (1 if negative in two's complement)
-- Z (Zero):     '1' when result = 0, '0' otherwise
-- C (Carry):    Carry out from arithmetic operations
-- V (Overflow): Overflow detection for signed arithmetic
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu_flags is
    generic (N : integer := 32);
    Port ( 
        a,b          : in STD_LOGIC_VECTOR(N-1 downto 0);  -- N-bit inputs
        alu_control  : in STD_LOGIC_VECTOR(1 downto 0);    -- 2-bit control
        result       : out STD_LOGIC_VECTOR(N-1 downto 0); -- N-bit result
        alu_flags    : out STD_LOGIC_VECTOR(3 downto 0)    -- NZCV : Negative, Zero, Carry, oVerflow
    );
end entity alu_flags;

architecture struct of alu_flags is
 
    -- Component declarations
    component mux2 is
        generic (N : integer := 32);
        Port ( 
            d0,d1  : in STD_LOGIC_VECTOR(N-1 downto 0);
            s      : in STD_LOGIC;
            y      : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    component mux4 is
        generic (N : integer := 32);
        Port ( 
            d0,d1,d2,d3 : in STD_LOGIC_VECTOR(N-1 downto 0);
            s           : in STD_LOGIC_VECTOR(1 downto 0);
            y           : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    component adder is
        generic (N : integer := 32);
        Port ( 
            a,b   : in STD_LOGIC_VECTOR(N-1 downto 0);
            cin   : in STD_LOGIC;
            s     : out STD_LOGIC_VECTOR(N-1 downto 0);
            cout  : out STD_LOGIC
        );
    end component;
    
    -- Internal signals
    signal v_xnor, v_xor, v_and             : STD_LOGIC;                                    -- overflow logic gates
    signal c_not, c_and                     : STD_LOGIC;                                    -- carry logic gates
    signal z_nand                           : STD_LOGIC_VECTOR(N-1 downto 0);               -- zero logic gates
    signal zero                             : STD_LOGIC;                                    -- zero flag
    signal cout                             : STD_LOGIC;                                    -- Adder cout
    signal m_or, m_and, sum_out, m2_out, m4_out, m_not : STD_LOGIC_VECTOR(N-1 downto 0);    -- MUX inputs and outputs

begin
    -- Logic operations
    v_xnor  <= not (alu_control(0) xor a(31) xor b(31));
    v_xor   <= a(31) xor sum_out(31);
    v_and   <= v_xnor and v_xor and c_not;
    c_not   <= not alu_control(1);
    c_and   <= c_not and cout;
    z_nand  <= m4_out nand m4_out;
    zero    <= '1' when z_nand = X"FFFFFFFF" else '0';
    m_and   <= a and b;
    m_or    <= a or b;
    m_not   <= not b;
        
    -- Instantiate components
    MUX_2: mux2
        generic map (N => N)
        port map (
            d0 => b,
            d1 => m_not,
            s  => alu_control(0),
            y  => m2_out);
        
    SUM: adder
        generic map (N => N)
        port map (
            a    => a,
            b    => m2_out,
            cin  => alu_control(0),
            s    => sum_out,
            cout => cout);
            
    MUX_4: mux4
        generic map (N => N)
        port map (
            d0 => sum_out,
            d1 => sum_out,
            d2 => m_and,
            d3 => m_or,
            s  => alu_control,
            y  => m4_out);
    
    -- Link outputs to corresponding signals
    alu_flags(0) <= v_and;
    alu_flags(1) <= c_and;
    alu_flags(2) <= zero;
    alu_flags(3) <= m4_out(31);
    result       <= m4_out;
end;