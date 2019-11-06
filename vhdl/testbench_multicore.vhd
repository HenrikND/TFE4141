----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06.11.2019 10:30:48
-- Design Name:
-- Module Name: testbench_multicore - Behavioral
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

entity testbench_multicore is
--  Port ( );
end testbench_multicore;

architecture Behavioral of testbench_multicore is

        component multicore is
           generic  (number_of_cores : integer := 5);
            port (
                clock, reset_n , last_message_in, message_in_ready, message_out_ready: in std_logic;
                e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
                data_out : out std_logic_vector(255 downto 0);
                data_ready, last_message_out : out std_logic
              ) ;
        end component ;
        -- signals
        signal clock : std_logic := '0';
        -- multicore
        signal multicore_reset_n, multicore_data_ready, multicore_last_message_out, multicore_last_message_in,multicore_message_in_ready,multicore_message_out_ready : std_logic;
        signal multicore_e, multicore_n, multicore_p, multicore_m, multicore_p_mon, multicore_data_out : std_logic_vector(255 downto 0);
        -- constants
        constant clock_period : time := 1us;
        -- files
        file file_vectors    : text;
        file file_results    : text;
        file file_error_log  : text;

begin
    multicore_test: multicore port map( clock => clock,
                                reset_n => multicore_reset_n,
                                e => multicore_e,
                                n => multicore_n,
                                p => multicore_p,
                                m => multicore_m,
                                p_mon => multicore_p_mon,
                                data_out => multicore_data_out,
                                data_ready => multicore_data_ready,
                                last_message_out => multicore_last_message_out,
                                last_message_in => multicore_last_message_in,
                                message_in_ready => multicore_message_in_ready,
                                message_out_ready => multicore_message_out_ready);

    clk_gen: process is
    begin
        clock <= '1';
        wait for 6 ns;
        clock <= '0';
        wait for 6 ns;
    end process;

end Behavioral;
