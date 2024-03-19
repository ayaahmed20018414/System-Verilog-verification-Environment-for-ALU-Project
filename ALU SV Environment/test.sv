`include "env.svh"
module test(alu_interface intf);
  Environment env;
  initial begin
    env=new(intf);
    env.gen.repeat_cnt=10000;
    env.run();
  end
endmodule
