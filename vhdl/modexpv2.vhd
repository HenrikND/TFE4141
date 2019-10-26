library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity modexp is
  port (
    clock, reset_n : in std_logic;
    e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
    data_out : out std_logic_vector(255 downto 0);
    data_ready : out std_logic
  ) ;
end modexp ;

architecture arch of modexp is
    component monprov2 is
      port(
        clock, reset_n : in std_logic;
        a, b, n : in std_logic_vector(255 downto 0);
        result : out std_logic_vector(255 downto 0);
        done : out std_logic;
        begin_monpro : in std_logic
      );
    end component;

    -- controll path signals
    signal monpro_begin, monpro_done : std_logic;
    signal state : std_logic_vector(3 downto 0) := "0000";
    signal counter : unsigned(8 downto 0);

    -- data path signals
    signal s_mon : std_logic_vector(255 downto 0);
    signal c :std_logic_vector(255 downto 0);
    signal e_shift : std_logic_vector(255 downto 0);
    signal result_buf : std_logic_vector(255 downto 0);

    -- monpro connectionsresult_buf
    signal monpro_a, monpro_b, monpro_n, monpro_result: std_logic_vector(255 downto 0);
  begin
    monpro : monprov2 port map(clock => clock,
                              reset_n => reset_n,
                              begin_monpro => monpro_begin,
                              a => monpro_a,
                              b => monpro_b ,
                              n => monpro_n,
                              result => monpro_result,
                              done => monpro_done);

    -- basic connection
    monpro_n <= n;
    data_out <= result_buf;

    controller : process( clock, reset_n )
    begin
      if( reset_n = '0' ) then
        state <= (others => '0');
        result_buf <= (others => '0');
        counter <= (others => '0');
        e_shift <= (others => '0');
        monpro_begin <= '0';


      elsif( rising_edge(clock) ) then
        -- finite state machine
        case( state ) is

          when "0000" =>
            state <= "0001";

          when "0001" =>
            if monpro_done = '1' then
              state <= "0100";
            end if ;

          when "0100" =>
            state <= "0101";
            counter <= counter + '1';
          when "0101" =>
            if monpro_done = '1' then
              if e_shift(0) = '1' then
                state <= "0110";
              else
                state <= "0100";
              end if;
            end if ;

          when "0110" =>
            state <= "0111";

          when "0111" =>
            if monpro_done = '1' and counter(8) = '1' then
              state <= "1000";
            elsif monpro_done = '1' then
              state <= "0100";
            end if ;

          when "1000" =>
            state <= "1001";

          when "1001" =>
            if monpro_done = '1'then
              state <= "1110";
            end if ;

          when "1110" =>

          when others =>

        end case ;

        if state(0) = '0' then
          monpro_begin <= '1';
        else
          monpro_begin <= '0';
        end if ;

        if state(2) = '1' and monpro_done = '1' then
           e_shift <= '0' & e_shift(255 downto 1);
        end if;

        if state = "1110" then
            data_ready <= '1';
        else
            data_ready <= '0';
        end if;

        -- input and output based on state
        if state(2) = '1' and state(1) = '0' then
          monpro_a <= C;
          monpro_b <= C;
          C <= monpro_result;
        elsif state(2) = '1' and state(1) = '1' then
          monpro_a <= S_mon;
          monpro_b <= C;
          C <= monpro_result;
        elsif state(3) = '1' then
          monpro_a <= (0 => '1', others => '0');
          monpro_b <= C;
          result_buf <= monpro_result;
        else -- init
          e_shift <= e;
          C <= p_mon;
          monpro_a <= m;
          monpro_b <= p;
          s_mon <= monpro_result;
          counter <= (others => '0');
        end if ;
      end if ;
    end process ; -- controller



end architecture ; -- arch