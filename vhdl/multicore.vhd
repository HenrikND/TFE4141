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


      -- modexp conections
begin



end architecture ; -- arch