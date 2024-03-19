class driver;
  transaction item;
  virtual alu_interface vif;
  mailbox gen2drv;
  int no_transaction;
  function new(virtual alu_interface vif, mailbox gen2drv);
    this.vif=vif;
    this.gen2drv=gen2drv;
  endfunction
  
  task reset();
    wait(!vif.rst_n);
    $display("==================================================");
    $display("==============reset asserted=================");
    vif.A<='b0;
    vif.B<='b0;
    vif.a_en<=1'b0;
    vif.b_en<=1'b0;
    vif.a_op<='b0;
    vif.b_op<='b0;
    vif.ALU_en<=1'b0;
    wait(vif.rst_n);
    $display("==============reset desserted=================");
    $display("===================================================");
  endtask
  task main();
    forever begin
      gen2drv.get(item);
      @(posedge vif.clk);
        vif.A<=item.A;
    	vif.B<=item.B;
    	vif.a_en<=item.a_en;
    	vif.b_en<=item.b_en;
    	vif.a_op<=item.a_op;
    	vif.b_op<=item.b_op;
    	vif.ALU_en<=item.ALU_en;
      	@(posedge vif.clk);
      	item.C<=vif.C;
        @(posedge vif.clk);
        item.print_info("Driver");
        no_transaction++;
    end
    
  endtask
  
endclass 