library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;

entity Testbench_SixteenBitAdder is
end entity;
architecture Behave of Testbench_SixteenBitAdder is
component SixteenBitAdder is
port(x : in std_logic_vector(15 downto 0);
y : in std_logic_vector(15 downto 0);
s : out std_logic_vector(15 downto 0);
c_out : out std_logic);
end component;

signal i1,i2 : std_logic_vector(15 downto 0);
signal o1 : std_logic_vector(15 downto 0);
signal oc: std_logic;
function to_std_logic(z: bit) return std_logic is
variable ret_val: std_logic;
begin
if (z = '1') then
ret_val := '1';
else
ret_val := '0';
end if;
return(ret_val);
end to_std_logic;

function to_string(z: string) return string is
variable ret_val: string(1 to z'length);
alias lz : string (1 to z'length) is z;
begin
ret_val := lz;
return(ret_val);
end to_string;

begin
process
variable err_flag : boolean := false;
File INFILE: text open read_mode is "SixteenBitAdder.txt";
FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";

---------------------------------------------------
-- edit the next two lines to customize
variable input_vector1: bit_vector ( 15 downto 0);
variable input_vector2: bit_vector ( 15 downto 0);
variable output_vector: bit_vector ( 15 downto 0);
variable output_carry: bit;
----------------------------------------------------
variable INPUT_LINE: Line;
variable OUTPUT_LINE: Line;
variable LINE_COUNT: integer := 0;

begin

while not endfile(INFILE) loop
LINE_COUNT := LINE_COUNT + 1;

readLine (INFILE, INPUT_LINE);
read (INPUT_LINE, input_vector1);
read (INPUT_LINE, input_vector2);
read (INPUT_LINE, output_vector);
read (INPUT_LINE, output_carry);

--------------------------------------
-- from input-vector to DUT inputs
--------------------------------------
i1 <= to_stdlogicvector(input_vector1);
i2 <= to_stdlogicvector(input_vector2);

-- let circuit respond.
wait for 5 ns;

--------------------------------------
-- check outputs.
if (o1 /= to_stdlogicvector(output_vector) or oc /= to_std_logic(output_carry)) then
write(OUTPUT_LINE,to_string("ERROR: in c1, line "));
write(OUTPUT_LINE, LINE_COUNT);
writeline(OUTFILE, OUTPUT_LINE);
err_flag := true;
end if;
--------------------------------------
end loop;

assert (err_flag) report "SUCCESS, all tests passed." severity note;
assert (not err_flag) report "FAILURE, some tests failed." severity error;

wait;
end process;

dut: SixteenBitAdder
port map(x => i1, y => i2, s => o1, c_out => oc);

end Behave;
