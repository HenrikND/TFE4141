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
        constant clock_pulse : time := 10ns;
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
        wait for clock_pulse/2;
        clock <= '0';
        wait for clock_pulse/2;
    end process;



    test_bench : process
        -- line variables
        variable line_vector : line;
        variable line_result : line;
        variable line_error  : line;

        -- read variables
        variable m_add      : std_logic_vector(255 downto 0);
        variable p_add      : std_logic_vector(255 downto 0);
        variable p_mon_add  : std_logic_vector(255 downto 0);
        variable n_add      : std_logic_vector(255 downto 0);
        variable e_add      : std_logic_vector(255 downto 0);
        variable fasit      : std_logic_vector(255 downto 0);

        -- log constants
        variable log_success        : string(1 to 22)   := "successfull run, run: ";
        variable log_error          : string(1 to 27)   := "error, values differ, run: ";
        variable space              : string(1 to 3)    := "   ";
        variable log_error_expected : string(1 to 10)   := "expected: ";
        variable log_error_got      : string(1 to 11)   := ", but got: ";

        -- counter
        variable run_number :integer := 0;

    begin
        -- connect to files
            -- maa endre pathen til å bli relativ
        file_open(file_vectors,   "C:\Users\hnd00\OneDrive\Github\TFE4141\multicore_testvectors.txt",    read_mode);
        file_open(file_results,   "C:/Users/hnd00/Desktop/project_1/project_1.srcs/sim_1/new/multicore_results.txt",   write_mode);
        file_open(file_error_log, "C:/Users/hnd00/Desktop/project_1/project_1.srcs/sim_1/new/multicore_error_log.txt", write_mode);

        -- loading the keys
        readline(file_vectors, line_vector);
        read(line_vector, p_add);
        read(line_vector, p_mon_add);
        read(line_vector, n_add);
        read(line_vector, e_add);

        multicore_e <= e_add;
        multicore_p <= p_add;
        multicore_p_mon <= p_mon_add;
        multicore_n <= n_add;

        -- resetting the system
        multicore_reset_n <= '0';
        wait until clock_pulse;
        multicore_reset_n <= '1';
        wait until clock_pulse;

        -- looping over different messages
        loop_over_messages : for i in 0 to 10 loop
            --accuire message
            readline(file_vectors, line_vector);
            read(line_vector, m_add);
            multicore_m <= m_add;
            -- give notice of new message
        end loop ; -- loop_over_messages
    end process ; -- test_bench


end Behavioral;
