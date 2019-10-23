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
    signal begin_monpro : std_logic;
    signal state : std_logic_vector(4 downto 0);

    -- data path signals
  begin
    monpro : monprov2 port map(clock => clock,
                              reset_n => reset_n,
                              begin_monpro => begin_monpro,
                              a => P,
                              b => m ,
                              n => n,
                              result => s_mon,
                              done => done_2);



    controller : process( clock, reset_n )
    begin
      if( reset_n = '0' ) then

      elsif( rising_edge(clock) ) then

      end if ;
    end process ; -- controller



end architecture ; -- arch