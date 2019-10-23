library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity modexp is
  port (
    clock, reset_n : in std_logic;
    e, p, n, m : in std_logic_vector(255 downto 0);
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
    signal monpro_begin : std_logic;
    signal state : std_logic_vector(3 downto 0);
    signal counter : std_logic_vector(8 downto 0);

    -- data path signals
    signal s_mon : std_logic_vector(255 downto 0);
    signal c :std_logic_vector(255 downto 0);
    signal e_shift : std_logic_vector(255 downto 0);

  begin
    monpro : monprov2 port map(clock => clock,
                              reset_n => reset_n,
                              begin_monpro => monpro_begin,
                              a => monpro_a,
                              b => monpro_b ,
                              n => monpro_n,
                              result => monpro_result,
                              done => monpro_done);

    controller : process( clock, reset_n )
    begin
      if( reset_n = '0' ) then
        state <= (others => '0');


      elsif( rising_edge(clock) ) then
        -- finite state machine
        case( state ) is

          when "0000" =>

            monpro_begin <= '1';
            state <= "0001";

          when "0001" =>
            monpro_begin <= '0';
            if monpro_done then
              state <= "0100"
            end if ;
          when "0100" =>

          when "0101" =>

          when "0110" =>

          when "0111" =>

          when "1000" =>

          when "1001" =>

          when "1111" =>

          when others =>

        end case ;

        if state() then
          
        end if ;
      end if ;
    end process ; -- controller



end architecture ; -- arch