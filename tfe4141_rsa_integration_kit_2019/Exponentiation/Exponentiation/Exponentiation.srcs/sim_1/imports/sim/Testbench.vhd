----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04.11.2019 12:51:23
-- Design Name:
-- Module Name: Testbench - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
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
-- TEXT IO
use STD.textio.all;
use ieee.std_logic_textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Testbench is
--  Port ( );

end Testbench;

architecture Behavioral of Testbench is
    component testbench_multicore is
    end component;

    component testbench_modexp is
    end component;

    component testbench_monpro is
    end component;
begin
    
    --testbench_monpro_1: Testbench_monpro;
    --modexp_test: Testbench_modexp;
    multicore_test: Testbench_multicore;

end Behavioral;
