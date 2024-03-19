interface alu_interface #(parameter IN_WIDTH=5, OUT_WIDTH=6)(input clk,rst_n);
  logic signed [IN_WIDTH-1:0] A;
  logic signed [IN_WIDTH-1:0] B;
  logic a_en;
  logic b_en;
  logic [2:0] a_op;
  logic [1:0] b_op;
  logic ALU_en;
  logic [OUT_WIDTH-1:0] C;
  
  clocking cb @(posedge clk);
    default input #0 output #1;
    inout A,B,ALU_en,a_op,b_op,a_en,b_en;
    input C;
  endclocking 
  modport dut(input A,B,a_op,b_op,a_en,b_en,ALU_en,rst_n,clk,output C);
  
  modport tb(clocking cb,input rst_n,clk);
  
endinterface 