// Code your design here
module ALU_design (alu_interface.dut intf);
  always @(posedge intf.clk or negedge intf.rst_n) begin
    if(!intf.rst_n) begin
      intf.C<='b0;
    end
    else if(intf.ALU_en) begin
      if(intf.a_en && !intf.b_en) begin
        case(intf.a_op)
          3'b000:begin
            intf.C<=intf.A + intf.B;
          end
          3'b001:begin
            intf.C<=intf.A - intf.B;
          end
          3'b010:begin
            intf.C<=intf.A ^ intf.B;
          end
          3'b011:begin
            intf.C<=intf.A  & intf.B;
          end
          3'b100:begin
            intf.C<=intf.A  & intf.B;
          end
          3'b101:begin
            intf.C<=intf.A  | intf.B;
          end
          3'b110:begin
            intf.C<=~(intf.A  ^ intf.B);
          end
          3'b111:begin
            $display("ERROR you aren't allowed to Enter this value Enter from 0 to 6 only");
          end   
        endcase
        
      end
      else if(!intf.a_en && intf.b_en) begin
        case(intf.b_op)
          2'b00:begin
            intf.C<=~(intf.A  & intf.B);
          end
          2'b01:begin
            intf.C<=intf.A  + intf.B;
          end
          2'b10:begin
            intf.C<=intf.A  + intf.B;
          end
          2'b11:begin
            $display("ERROR you aren't allowed to Enter this value Enter from 0 to 2 only");
          end
        endcase
      end
      else if(intf.a_en && intf.b_en) begin
       case(intf.b_op)
          2'b00:begin
            intf.C<=intf.A  ^ intf.B;
          end
          2'b01:begin
            intf.C<=~(intf.A  ^ intf.B);
          end
          2'b10:begin
            intf.C<=intf.A  - 1;
          end
          2'b11:begin
            intf.C<=intf.B  + 2;
          end
        endcase
      end
      else begin
        intf.C<='b0;
      end
    end
    else begin
      intf.C<='b0;
    end     
  end
  
  
  
  
endmodule