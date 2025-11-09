----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 10/29/2025 09:16:05 PM
-- Design Name: 
-- Module Name: alu_decoder - synth
-- Project Name: project_lab3
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    ALU instruction decoder for ARM processor.
--    Decodes ALU operation type and generates ALUControl and FlagW signals.
--    Supports ADD, SUB, AND, ORR operations with flag update control.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_decoder is
    Port ( 
        Funct       : in STD_LOGIC_VECTOR (4 downto 0);
        ALUOp       : in STD_LOGIC;
        ALUControl  : out STD_LOGIC_VECTOR (1 downto 0);
        FlagW       : out STD_LOGIC_VECTOR (1 downto 0)
    );
end alu_decoder;

architecture synth of alu_decoder is
begin
    process(Funct, ALUOp)
    begin
        if ALUOp = '0' then
            ALUControl  <= "00";
            FlagW       <= "00";
        else
            case Funct(4 downto 1) is
                when "0100" =>          -- ADD
                    ALUControl  <= "00";
                    FlagW(1)    <= Funct(0);
                    FlagW(0)    <= Funct(0);
                when "0010" =>          -- SUB
                    ALUControl  <= "01";
                    FlagW(1)    <= Funct(0);
                    FlagW(0)    <= Funct(0);                
                when "0000" =>          -- AND
                    ALUControl  <= "10";
                    FlagW(1)    <= Funct(0);
                    FlagW(0)    <= '0';                
                when "1100" =>          -- ORR
                    ALUControl  <= "11";
                    FlagW(1)    <= Funct(0);
                    FlagW(0)    <= '0';                
                when others =>
            end case;
        end if;
    end process;
end synth;
