// Code your testbench here
// or browse Examples
`include "interface.sv"
`include "test.sv"
module testbench_top();
  bit clk;
  bit rst_n;
  alu_interface intf(clk,rst_n);
  ALU_design dut(intf.dut);
  test tb(intf.tb );
  always #5 clk=~clk;
  initial begin
    rst_n=0;
    repeat(50)@(posedge clk);
    rst_n=1;
    repeat (5000)@(posedge clk);
    rst_n=0;
    repeat (50)@(posedge clk);
    rst_n=1;
    repeat (7000)@(posedge clk);
    $finish;
  end
  
endmodule
