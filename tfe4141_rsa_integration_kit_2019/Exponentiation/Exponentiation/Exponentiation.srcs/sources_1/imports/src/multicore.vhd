    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;


    entity Exponentiation is
        generic  (number_of_cores : integer := 2);
        port (
            clock, reset_n , last_message_in, message_in_valid, message_out_ready: in std_logic;
            e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
            data_out : out std_logic_vector(255 downto 0);
            message_out_valid, message_in_ready, last_message_out : out std_logic
          );
    end Exponentiation ;

    architecture arch of Exponentiation is
        -- componets used in architecture
        component modexp is
            port (
                clock, reset_n: in std_logic;
                e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
                data_out : out std_logic_vector(255 downto 0);
                data_ready : out std_logic
              );
        end component;

        -- type definitions
        type data_arr_t is array (0 to number_of_cores - 1) of std_logic_vector(255 downto 0);
        subtype flag_t is std_logic_vector(number_of_cores -1 downto 0);
        subtype state_t is integer range 0 to number_of_cores - 1;

        -- modexp connections
        signal modexp_m             : data_arr_t;
        signal modexp_data          : data_arr_t;
        signal modexp_ready         : flag_t;
        signal modexp_reset_n       : flag_t;

        -- control signals
        signal modexp_state         : state_t;
        signal output_state         : state_t;

        -- modexp flags
        signal flag_last_message    : flag_t;
        signal flag_busy            : flag_t;

    begin

    -- generate the nessesary number of blocks
        g_gen_modexp: for i in 0 to number_of_cores -1 generate
            uut: modexp port map(clock => clock,
                                reset_n => modexp_reset_n(i),
                                e => e,
                                n => n,
                                p => p,
                                m => modexp_m(i),
                                p_mon => p_mon,
                                data_out => modexp_data(i),
                                data_ready => modexp_ready(i));

        end generate g_gen_modexp;




        controll : process( clock, reset_n )
        begin
            if( reset_n = '0' ) then
                modexp_state <= 0;
                modexp_state <= 0;
                modexp_reset_n <= (others => '0');
                flag_busy <= (others => '0');
            elsif( rising_edge(clock) ) then
                modexp_reset_n <= flag_busy;
                -- push message
                if flag_busy(modexp_state) = '0' and message_in_valid = '1' then
                    modexp_m(modexp_state) <= m;
                    flag_busy(modexp_state) <= '1';
                    message_in_ready <= '1';
                    if last_message_in = '0' then

                        -- check if input state has reach max
                        if modexp_state = number_of_cores - 1 then
                            modexp_state <= 0;
                        else
                            modexp_state <= modexp_state + 1;
                        end if ;
                        flag_last_message <= (others => '0');
                    else
                        flag_last_message(modexp_state) <= '1';
                    end if ;
                else
                    message_in_ready <= '0';
                end if ;

                -- check if core is done and send data out
                if flag_busy(output_state) = '1' and modexp_ready(output_state) = '1' then
                    data_out <= modexp_data(output_state);
                    message_out_valid <= '1';

                    if message_out_ready  = '1' then
                        if flag_last_message(output_state) = '1' then
                            last_message_out <= '1';
                        else
                            last_message_out <= '0';
                            if output_state = number_of_cores -1 then
                                output_state <= 0;
                            else
                                output_state <= output_state + 1;
                            end if;
                        end if ;
                        flag_busy(output_state) <= '0';
                    end if ;
                else
                    message_out_valid <= '0';
                end if ;
            end if ;
        end process ; -- controll

    end architecture ; -- arch