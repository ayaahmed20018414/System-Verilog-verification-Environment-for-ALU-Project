class transaction;
  randc logic signed [4:0] A;
  randc logic signed [4:0] B;
  rand logic a_en;
  rand logic b_en;
  randc logic [2:0] a_op;
  randc logic [1:0] b_op;
  rand logic ALU_en;
  logic signed [5:0] C;
  bit rst_n;
  constraint a_op_val {a_op !=7;}
  constraint b_op_val {if(!a_en && b_en) {
    b_op !=3;}}
  constraint a_en_val {a_en dist {1:=60 ,0:=40};} 
  constraint b_en_val {b_en dist {1:=50 ,0:=50};}
  constraint ALU_en_val {ALU_en dist {1:=95 ,0:=5};} 
  
    function void print_info(string name);
                       $display("=====================%s informatin===========================",name);
           $display("===============transaction information===============================");
           $display("A=%0d, B=%0d, a_en=%0d, b_en=%0d, a_op=%0d, b_op=%0d, ALU_en=%0d, C=%0d",A,B,a_en,b_en,a_op,b_op,ALU_en,C);
           $display("==============================================================");
                       
                       
    endfunction 
endclass 
