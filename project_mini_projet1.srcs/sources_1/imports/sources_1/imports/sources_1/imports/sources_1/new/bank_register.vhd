----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 10/05/2025 05:59:44 PM
-- Design Name: 
-- Module Name: bank_register - struct
-- Project Name: project_lab2
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    Complete ARM data path connecting register file, ALU, data memory, and extend unit.
--    Implements the red-dotted section from Figure 1 with all control signals and multiplexers.
-- 
-- Dependencies: register_file, extend, data_memory, alu_flags, mux2
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Complete implementation with all components and multiplexers
-- Revision 1.01 - Added outputs for ALUResult and WriteData
-- Revision 2.00 - Added asynchronous RESET
-- Revision 2.01 - Added R15 to datapath
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bank_register is
    generic ( 
        M : integer := 32;
        N : integer := 4
    );
    port (
        clk          : in STD_LOGIC;
        rst          : in STD_LOGIC;                        -- Asynchronous RESET (active LOW)
        -- Control Signals (blue signals from diagram)
        RegWrite     : in STD_LOGIC;
        ImmSrc       : in STD_LOGIC_VECTOR(1 downto 0);
        ALUSrc       : in STD_LOGIC;
        ALUControl   : in STD_LOGIC_VECTOR(1 downto 0);
        MemWrite     : in STD_LOGIC;
        MemtoReg     : in STD_LOGIC;
        RegSrc       : in STD_LOGIC_VECTOR(1 downto 0);
        R15          : in STD_LOGIC_VECTOR(M-1 downto 0);
        -- Instruction Input
        Instr        : in STD_LOGIC_VECTOR(M-1 downto 0);
        -- Outputs
        ALUFlags     : out STD_LOGIC_VECTOR(N-1 downto 0);  -- 4 flags: N, Z, C, V
        Result       : out STD_LOGIC_VECTOR(M-1 downto 0);  -- Mux output after memory
        ALUResult    : out STD_LOGIC_VECTOR(M-1 downto 0);
        WriteData    : out STD_LOGIC_VECTOR(M-1 downto 0)
        );
end bank_register;

architecture struct of bank_register is

    -- Component Declarations
    component register_file is
        generic(N: integer := 4; M: integer := 32);
        Port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            we3 : in STD_LOGIC;
            a1  : in STD_LOGIC_VECTOR(N-1 downto 0);
            a2  : in STD_LOGIC_VECTOR(N-1 downto 0);
            a3  : in STD_LOGIC_VECTOR(N-1 downto 0);
            wd3 : in STD_LOGIC_VECTOR(M-1 downto 0);
            r15 : in STD_LOGIC_VECTOR(M-1 downto 0);
            rd1 : out STD_LOGIC_VECTOR(M-1 downto 0);
            rd2 : out STD_LOGIC_VECTOR(M-1 downto 0)
        );
    end component;
    
    component extend is
        generic(N: integer := 24; M: integer := 32);
        Port ( 
            imm_src : in STD_LOGIC_VECTOR(1 downto 0);
            input   : in STD_LOGIC_VECTOR(N-1 downto 0);
            output  : out STD_LOGIC_VECTOR(M-1 downto 0)
        );
    end component;
    
    component data_memory is
        generic(M: integer := 32);
        Port ( 
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            we  : in STD_LOGIC;
            a   : in STD_LOGIC_VECTOR(M-1 downto 0);
            wd  : in STD_LOGIC_VECTOR(M-1 downto 0);
            rd  : out STD_LOGIC_VECTOR(M-1 downto 0)
        );
    end component;
    
    component alu_flags is
        generic (N : integer := 32);
        Port ( 
            a,b          : in STD_LOGIC_VECTOR(N-1 downto 0);  -- N-bit inputs
            alu_control  : in STD_LOGIC_VECTOR(1 downto 0);    -- 2-bit control
            result       : out STD_LOGIC_VECTOR(N-1 downto 0); -- N-bit result
            alu_flags    : out STD_LOGIC_VECTOR(3 downto 0)    -- NZCV : Negative, Zero, Carry, oVerflow
        );
    end component;
    
    component mux2 is
        generic (N : integer := 32);
        Port ( 
            d0,d1 : in STD_LOGIC_VECTOR(N-1 downto 0);  -- N-bit input vectors
            s     : in STD_LOGIC;                       -- Select line
            y     : out STD_LOGIC_VECTOR(N-1 downto 0)  -- N-bit output vector
        );
    end component;
    
    -- Internal Signals
    signal WD3, ExtImm, SrcA, SrcB, ReadData : STD_LOGIC_VECTOR(M-1 downto 0);
    signal RA1, RA2 : STD_LOGIC_VECTOR(3 downto 0);
begin

    -- Instantiate MUX
    MUX_1:      mux2
        generic map (N => N)
        port map (
            d0 => Instr(19 downto 16),
            d1 => "1111",
            s  => RegSrc(0),
            y  => RA1
        );
            
    MUX_2:      mux2
        generic map (N => N)
        port map (
            d0 => Instr(3 downto 0),
            d1 => Instr(15 downto 12),
            s  => RegSrc(1),
            y  => RA2
        );
        
    MUX_3:      mux2
        generic map (N => M)
        port map (
            d0 => WriteData,
            d1 => ExtImm,
            s  => ALUSrc,
            y  => SrcB
        );
                
    MUX_4:      mux2
        generic map (N => M)
        port map (
            d0 => ALUResult,
            d1 => ReadData,
            s  => MemtoReg,
            y  => WD3
        );
        
    -- Instantiate Register File
    REG_FILE:   register_file
        generic map (N => N, M => M)
        port map (
            clk => clk,
            rst => rst,
            we3 => RegWrite,
            a1  => RA1,
            a2  => RA2,
            a3  => Instr(15 downto 12),
            wd3 => WD3,
            r15 => R15, 
            rd1 => SrcA,
            rd2 => WriteData
        );
    
    -- Instantiate Extend
    EXT:        extend
        generic map (N => 24, M => M)
        port map (
            imm_src => ImmSrc,
            input   => Instr(23 downto 0),
            output  => ExtImm
        );
        
    -- Instantiate Data Memory
    DATA_MEM:   data_memory
        generic map (M => M)
        port map (
            clk => clk,
            rst => rst,
            we  => MemWrite,
            a   => ALUResult,
            wd  => WriteData,
            rd  => ReadData
        );
        
    -- Intantiate ALU
    ALU:        alu_flags
        generic map (N => M)
        port map (
            a           => SrcA,
            b           => SrcB,
            alu_control => ALUControl,
            result      => ALUResult,
            alu_flags   => ALUFlags
        );
        
    -- Link outputs
    Result <= WD3;
end struct;
