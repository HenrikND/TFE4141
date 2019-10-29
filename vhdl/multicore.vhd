library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity multicore is
    generic  (number_of_cores : integer := 5);
    port (
        clock, reset_n , last_message_in, message_in_ready, message_out_ready: in std_logic;
        e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
        data_out : out std_logic_vector(255 downto 0);
        data_ready : out std_logic
      ) ;
end multicore ;

architecture arch of multicore is
    -- componets used in architecture
    component modexp is
        port (
            clock, reset_n: in std_logic;
            e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
            data_out : out std_logic_vector(255 downto 0);
            data_ready : out std_logic
          ) ;
    end component;

    -- type definitions
    type data_arr_t is array (0 to number_of_cores) of std_logic_vector(255 downto 0);
    type flag_t is std_logic_vector(number_of_cores downto 0);

    -- modexp connections
    signal modexp_m             : data_arr_t;
    signal modexp_data          : data_arr_t;
    signal modexp_ready         : flag_r;
    signal modexp_reset_n       : flag_r;

    -- control signals
    signal modexp_state         : integer;
    signal input_state          : std_logic_vector(1 downto 0);
    signal output_state         : std_logic_vector(1 downto 0);

    -- modexp flags
    signal flag_last_message    : flag_t;
    signal flag_busy            : flag_t;
    --signal flag_number          : integer;

begin

-- generate the nessesary number of blocks
    g_gen_modexp: for i in 0 to number_of_cores -1 generate
        uut: modexp port map( clock => clock,
                            reset_n => modexp_reset_n(i),
                            e => e,
                            n => n,
                            p => p,
                            m => modexp_m(i),
                            p_mon => p_mon,
                            data_out => modexp_data(i),
                            data_ready => modexp_ready(i));
        -- when busy is 1 the modexp core should function as normal but when 0 the core should be in a reset state
        modexp_reset_n(i) <= flag_busy(i) or reset_n;
    end generate g_gen_modexp;




    controll : process( clock, reset_n )
    begin
        if( reset_n = '0' ) then
            modexp_state <= 0;
            input_state <= "00";
            modexp_reset_n <= (others => '0');
        elsif( rising_edge(clock) ) then
            -- check if input state has reach max
            if modexp_state > number_of_cores then
                modexp_state <= 0;
            end if;

            -- good chance needs to be changed, maybe two stated instead, run and finish
            case(input_state) is
            -- boot state
            when "00" =>
                if modexp_state > number_of_cores then
                    input_state <= "01";
                end if;
            --looping over messages
            when "01" =>
                if last_message_in = '1' then
                    input_state <= "10";
                end if;
            -- stoping since reach last message
            when "10" =>

            when others =>
                input_state <= "00";
            end case;
        end if ;

        -- push message
        if flag_busy(input_state) = '0' then
            modexp_m(input_state) <= m;
            input_state <= input_state + 1;
        end if ;

        -- check if core is done and send data out
        if flag_busy(output_state) = '1' and modexp_ready(output_state) = '1' then
            data_out <= modexp_data(output_state);
            data_ready <= '1';
            if message_out_ready  = '1' then
                output_state <= output_state + 1;
                modexp_busy(output_state) <= '0'
            end if ;
        else
            data_ready <= '0';
        end if ;
    end process ; -- controll

end architecture ; -- arch