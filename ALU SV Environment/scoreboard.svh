class scoreboard;
  transaction item;
  mailbox mon2scb;
  int no_transactions;
  function new(mailbox mon2scb);
    this.mon2scb=mon2scb;
  endfunction
  task main();
    bit signed [5:0] Expected_out1,Expected_out2,Expected_out3;
    forever begin
    mon2scb.get(item);
    case(item.a_op)
      3'b000:begin
        Expected_out1=item.A + item.B;
      end
      3'b001:begin
        Expected_out1=item.A - item.B;
      end
      3'b010:begin
        Expected_out1=item.A ^ item.B;
      end
      3'b011:begin
        Expected_out1=item.A & item.B;
      end
      3'b100:begin
        Expected_out1=item.A & item.B;
      end
      3'b101:begin
        Expected_out1=item.A | item.B;
      end
      3'b110:begin
        Expected_out1=~(item.A ^ item.B);
      end
    endcase
      case(item.b_op)
        2'b00:begin
          Expected_out2=~(item.A & item.B);
        end
        2'b01:begin
          Expected_out2=item.A + item.B;
        end
        2'b10:begin
          Expected_out2=item.A + item.B;
        end
      endcase
      case(item.b_op)
        2'b00:begin
          Expected_out3=item.A  ^ item.B;
        end
        2'b01:begin
          Expected_out3=~(item.A  ^ item.B);
        end
        2'b10:begin
          Expected_out3=item.A  - 1;
        end
        2'b11:begin
          Expected_out3=item.B  + 2;
        end
       endcase
    if(item.rst_n==0 && item.C !=0) begin
      $error("output is not as Expected Actual value is %0d and Expected value is 0",item.C);
    end
    else if(item.rst_n==1 && item.ALU_en==0 && item.C !=0) begin
      $error("output is not as Expected Actual value is %0d and Expected value is 0",item.C);
    end
    else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==0 && item.b_en==0 && item.C !=0) begin
      $error("output is not as Expected Actual value is %0d and Expected value is 0",item.C);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==0 && item.a_op==0 && !(item.C ==item.A +item.B)) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out1);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==0 && item.a_op==1 && !(item.C ==item.A - item.B)) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out1);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==0 && item.a_op==2 && !(item.C ==(item.A ^ item.B))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out1);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==0 && item.a_op==3 && !(item.C ==(item.A & item.B))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out1);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==0 && item.a_op==4 && !(item.C ==(item.A & item.B))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out1);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==0 && item.a_op==5 && !(item.C ==(item.A | item.B))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out1);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==0 && item.a_op==6 && !(item.C ==(~(item.A ^ item.B)))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out1);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==0 && item.b_en==1 && item.b_op==0 && !(item.C ==(~(item.A & item.B)))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out2);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==0 && item.b_en==1 && item.b_op==1 && !(item.C == (item.A + item.B))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out2);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==0 && item.b_en==1 && item.b_op==2 && !(item.C == (item.A + item.B))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out2);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==1 && item.b_op==0 && !(item.C == (item.A ^ item.B))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out3);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==1 && item.b_op==1 && !(item.C == (~(item.A ^ item.B)))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out3);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==1 && item.b_op==2 && !(item.C == (item.A - 1))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out3);
    end
      else if(item.rst_n==1 && item.ALU_en==1 && item.a_en==1 && item.b_en==1 && item.b_op==3 && !(item.C == (item.B + 2))) begin
      $error("output is not as Expected Actual value is %0d and Expected value is %0d",item.C,Expected_out3);
    end
    else begin
      $display("test case passed! Actual output = Expected value = %0d",item.C);
    end
      no_transactions++;
      item.print_info("Scoreboard");
    end
  endtask
  
endclass 