// Code your design here
module alu(alu_interface.dut intf);
  logic [8:0] result_temp;
  always @(posedge intf.clk or posedge intf.reset) begin
    if(intf.reset) begin
      intf.result<='b0;
      intf.carry<=1'b0;
    end
    else begin
      {intf.carry,intf.result} <=result_temp;
    end
  end
    always @(*) begin
      case(intf.op_code)
        4'b0000:begin
          result_temp<=intf.a+intf.b;
        end
       4'b0001:begin
         result_temp<=intf.a-intf.b;
        end
       4'b0010:begin
         result_temp<=intf.a*intf.b;
        end
        4'b0011:begin
          result_temp<=intf.a/intf.b;
        end
        
      endcase
  end
  
  
endmodule
