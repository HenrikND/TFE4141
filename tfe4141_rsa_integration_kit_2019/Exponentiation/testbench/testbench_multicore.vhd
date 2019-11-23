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

        component Exponentiation is
           generic  (number_of_cores : integer := 5);
           port (
            clock, reset_n , last_message_in, message_in_valid, message_out_ready: in std_logic;
            e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
            data_out : out std_logic_vector(255 downto 0);
            message_out_valid, last_message_out, message_in_ready : out std_logic
            ) ;
        end component ;
        -- signals
        signal clock : std_logic := '0';
        signal done_receiving_messages : std_logic := '0';
        -- multicore
        signal multicore_reset_n, multicore_message_out_valid, multicore_last_message_out, multicore_last_message_in,multicore_message_in_ready,multicore_message_out_ready,multicore_message_in_valid : std_logic;
        signal multicore_e, multicore_n, multicore_p, multicore_m, multicore_p_mon, multicore_data_out : std_logic_vector(255 downto 0);
        -- constants
        constant clock_pulse : time := 10ns;
        -- files
        file file_vectors       : text;
        file file_results       : text;
        file file_error_log     : text;
        file file_fasit_vectors : text;

begin
    multicore_test: Exponentiation port map( clock => clock,
                                reset_n => multicore_reset_n,
                                e => multicore_e,
                                n => multicore_n,
                                p => multicore_p,
                                m => multicore_m,
                                p_mon => multicore_p_mon,
                                data_out => multicore_data_out,
                                message_out_valid => multicore_message_out_valid,
                                last_message_out => multicore_last_message_out,
                                last_message_in => multicore_last_message_in,
                                message_in_ready => multicore_message_in_ready,
                                message_out_ready => multicore_message_out_ready,
                                message_in_valid => multicore_message_in_valid);

    clk_gen: process is
    begin
        if done_receiving_messages = '1' then
            wait;
        else
            clock <= '1';
            wait for clock_pulse/2;
            clock <= '0';
            wait for clock_pulse/2;
        end if;
    end process;



    test_bench : process
        -- line variables
        variable line_vector : line;


        -- read variables
        variable m_add      : std_logic_vector(255 downto 0);
        variable p_add      : std_logic_vector(255 downto 0);
        variable p_mon_add  : std_logic_vector(255 downto 0);
        variable n_add      : std_logic_vector(255 downto 0);
        variable e_add      : std_logic_vector(255 downto 0);

        -- counter
        variable run_number :integer := 0;

    begin
        -- connect to files
            -- maa endre pathen til å bli relativ
        file_open(file_vectors,   "userdefined\testvectors\multicore_testvectors.txt",    read_mode);

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
        multicore_last_message_in <= '0';
        -- resetting the system
        multicore_reset_n <= '0';
        wait for clock_pulse;
        multicore_reset_n <= '1';
        wait for clock_pulse;

        -- looping over different messages
        loop_over_messages : for i in 0 to 10-1 loop
            --accuire message
            readline(file_vectors, line_vector);
            read(line_vector, m_add);
            multicore_m <= m_add;
            -- give notice of new message
            multicore_message_in_valid <= '1';
            wait until multicore_message_in_ready = '1';
            multicore_message_in_valid <= '0';
            wait for 4*clock_pulse;
        end loop ; -- loop_over_messages

        -- last message
        --accuire message
        readline(file_vectors, line_vector);
        read(line_vector, m_add);
        multicore_m <= m_add;
        -- give notice of new message
        multicore_message_in_valid <= '1';
        multicore_last_message_in <= '1';
        wait until multicore_message_in_ready = '1';
        multicore_message_in_valid <= '0';
        wait for 4*clock_pulse;

        -- wrong place: done_receiving_messages <= '1';
        wait;
    end process ; -- test_bench

    read_messages_and_compare : process
        -- line variables
        variable line_vector : line;
        variable line_result : line;
        variable line_error  : line;
        
        -- read variables
        variable fasit      : std_logic_vector(255 downto 0);

        -- log constants
        variable log_success        : string(1 to 22)   := "successfull run, run: ";
        variable log_error          : string(1 to 27)   := "error, values differ, run: ";
        variable space              : string(1 to 3)    := "   ";
        variable log_error_expected : string(1 to 10)   := "expected: ";
        variable log_error_got      : string(1 to 11)   := ", but got: ";

        -- signals
        --signal data : std_logic_vector(255 downto 0);
        variable message_number : integer ;

    begin
        done_receiving_messages <= '0';
        multicore_message_out_ready <= '0';
        --open file
        file_open(file_fasit_vectors,   "userdefined\testvectors\multicore_fasitvectors.txt",    read_mode);
        file_open(file_results,   "userdefined\multicore_results.txt",   write_mode);
        file_open(file_error_log, "userdefined\multicore_error_log.txt", write_mode);
        message_number := 0;
        loop_over_messages : while multicore_last_message_out /='1' loop
            wait for clock_pulse;
            --read the fasit from file
            readline(file_fasit_vectors, line_vector);
            read(line_vector, fasit);

            -- wait for message
            multicore_message_out_ready <= '1';
            wait until multicore_message_out_valid = '1';

            -- check result
            if multicore_data_out = fasit then
                write(line_result, log_success ,left, 22);
                write(line_result, message_number, right, 5);
                write(line_result, space ,left, 3);
                write(line_result, multicore_data_out, right, 255);
            else
                write(line_result, log_error ,left, 27);
                write(line_result, message_number, right, 16);
                write(line_result, space ,left, 3);
                write(line_result, multicore_data_out, right, 255);

                write(line_error, log_error, left, 27);
                write(line_error, message_number, right, 5);
                write(line_error, space ,left, 3);
                write(line_error, log_error_expected, left, 10);
                write(line_error, fasit, right, 255);
                write(line_error, log_error_got, right, 11);
                write(line_error, multicore_data_out, right, 255);

                writeline(file_error_log, line_error);
            end if;
            writeline(file_results, line_result);
            multicore_message_out_ready <= '0';
            message_number := message_number + 1;

        end loop ; -- loop_over_messages



        -- close files
        file_close(file_fasit_vectors);
        file_close(file_results);
        file_close(file_error_log);

        -- shutdown the system
        done_receiving_messages <= '1';
        wait;
    end process ; -- read_messages_and_compare


end Behavioral;