----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/02/2025 09:40:52 PM
-- Design Name: Control Unit Decoder
-- Module Name: ctrl_unit_decoder - struct
-- Project Name: project_lab4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    This module implements the control unit decoder for the processor, 
--    combining the main decoder, ALU decoder, and PC logic components. 
-- 
-- Dependencies: 
--    pc_logic.vhd, main_decoder.vhd, alu_decoder.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Component interconnections completed
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ctrl_unit_decoder is
    Port ( 
           Op           : in STD_LOGIC_VECTOR (1 downto 0);
           Funct        : in STD_LOGIC_VECTOR (5 downto 0);
           Rd           : in STD_LOGIC_VECTOR (3 downto 0);
           FlagW        : out STD_LOGIC_VECTOR (1 downto 0);
           PCS          : out STD_LOGIC;
           RegW         : out STD_LOGIC;
           MemW         : out STD_LOGIC;
           MemtoReg     : out STD_LOGIC;
           ALUSrc       : out STD_LOGIC;
           ImmSrc       : out STD_LOGIC_VECTOR (1 downto 0);
           RegSrc       : out STD_LOGIC_VECTOR (1 downto 0);
           ALUControl   : out STD_LOGIC_VECTOR (1 downto 0)
    );
end ctrl_unit_decoder;

architecture struct of ctrl_unit_decoder is

    -- Component declarations
    component pc_logic is
        Port ( 
            Rd      : in STD_LOGIC_VECTOR (3 downto 0);
            Branch  : in STD_LOGIC;
            RegW    : in STD_LOGIC;
            PCS     : out STD_LOGIC
        );
    end component;
    
    component main_decoder is
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
    end component;

    component alu_decoder is
        Port ( 
            Funct       : in STD_LOGIC_VECTOR (4 downto 0);
            ALUOp       : in STD_LOGIC;
            ALUControl  : out STD_LOGIC_VECTOR (1 downto 0);
            FlagW       : out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;
    
    -- Internal signals
    signal RW, ALUOp, Branch : STD_LOGIC;

begin
    RegW <= RW;
    
    -- Component instantiation
    PC:     pc_logic
        port map (
            Rd          => Rd,
            Branch      => Branch,
            RegW        => RW,
            PCS         => PCS
        );
    MAIN:   main_decoder
        port map ( 
            Op          => Op,
            Funct       => Funct,
            RegW        => RW,
            MemW        => MemW,
            MemtoReg    => MemtoReg,
            ALUSrc      => ALUSrc,
            ImmSrc      => ImmSrc,
            RegSrc      => RegSrc,
            ALUOp       => ALUOp,
            Branch      => Branch
        );
    ALU:    alu_decoder
        port map ( 
            Funct       => Funct(4 downto 0),
            ALUOp       => ALUOp,
            ALUControl  => ALUControl,
            FlagW       => FlagW
        );
end struct;
