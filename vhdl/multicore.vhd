library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity multicore is
    port (
        clock, reset_n : in std_logic;
        e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
        data_out : out std_logic_vector(255 downto 0);
        data_ready : out std_logic
      ) ;
end multicore ;

architecture arch of multicore is
    component modexpv2 is
        port (
            clock, reset_n : in std_logic;
            e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
            data_out : out std_logic_vector(255 downto 0);
            data_ready : out std_logic
          ) ;
      end component;

      signal input_state, output_state : std_logic_vector(4 downto 0);
      -- modexp conections
      signal modexp_m_1, modexp_data_1, modexp_ready_1 : std_logic_vector(255 downto 0);
begin

-- modexp blocks
modexp_1 : modexpv2 port map( clock => clock,
                            reset_n => reset_n,
                            e => e,
                            n => n,
                            p => p,
                            m => modexp_m_1,
                            p_mon => p_mon,
                            data_out => modexp_data_1,
                            data_ready => modexp_ready_1);



input_state_machine : process( clock, reset_n )
begin
  if( reset_n = '0' ) then

  elsif( rising_edge(clock) ) then
    case( input_state ) is

        when IDLE =>


        when others =>

    end case ;
  end if ;
end process ; -- input_state_machine



output_state_machine : process( clock, reset_n )
begin
  if( reset_n = '0' ) then

  elsif( rising_edge(clock) ) then

  end if ;
end process ; -- output_state_machine



end architecture ; -- arch