----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 10/29/2025 05:26:44 PM
-- Design Name: 
-- Module Name: main_decoder - synth
-- Project Name: project_lab3
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    Main instruction decoder for ARM processor.
--    Decodes instruction type based on Op and Funct bits and generates control signals.
--    Supports DP Reg, DP Imm, STR, and LDR instruction types.
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

entity main_decoder is
    Port ( 
        Op          : in STD_LOGIC_VECTOR (1 downto 0);
        Funct       : in STD_LOGIC_VECTOR (5 downto 0);
        RegW        : out STD_LOGIC;
        MemW        : out STD_LOGIC;
        MemtoReg    : out STD_LOGIC;
        ALUSrc      : out STD_LOGIC;
        ImmSrc      : out STD_LOGIC_VECTOR (1 downto 0);
        RegSrc      : out STD_LOGIC_VECTOR (1 downto 0);
        ALUOp       : out STD_LOGIC;
        Branch      : out STD_LOGIC
    );
end main_decoder;

architecture synth of main_decoder is
begin
    process(Op, Funct)
    begin
        case Op is
            when "00" =>
                if Funct(5) = '0' then  -- Type: DP Reg
                    RegW        <= '1';
                    MemW        <= '0';
                    MemtoReg    <= '0';
                    ALUSrc      <= '0';
                    ImmSrc      <= "XX";
                    RegSrc      <= "00";
                    ALUOp       <= '1';
                    Branch      <= '0';
                else                    -- Type: DP Imm 
                    RegW        <= '1';
                    MemW        <= '0';
                    MemtoReg    <= '0';
                    ALUSrc      <= '1';
                    ImmSrc      <= "00";
                    RegSrc      <= "X0";
                    ALUOp       <= '1';
                    Branch      <= '0';
                end if;
            when "01" =>
                if Funct(0) = '0' then  -- Type: STR
                    RegW        <= '0';
                    MemW        <= '1';
                    MemtoReg    <= 'X';
                    ALUSrc      <= '1';
                    ImmSrc      <= "01";
                    RegSrc      <= "10";
                    ALUOp       <= '0';
                    Branch      <= '0';                    
                else                    -- Type: LDR
                    RegW        <= '1';
                    MemW        <= '0';
                    MemtoReg    <= '1';
                    ALUSrc      <= '1';
                    ImmSrc      <= "01";
                    RegSrc      <= "X0";
                    ALUOp       <= '0';
                    Branch      <= '0';                   
                end if;
            when others =>
        end case;
    end process;
end synth;
