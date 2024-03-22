class monitor;
  virtual alu_interface vif;
  transaction item;
  mailbox mon2scb;
  mailbox mon2cov;
  function new(virtual alu_interface vif, mailbox mon2scb,mon2cov);
    this.vif=vif;
    this.mon2scb=mon2scb;
    this.mon2cov=mon2cov;
  endfunction
  
  task main();
    forever begin
    item=new();
    @(posedge vif.clk);
    item.A=vif.A;
    item.B=vif.B;
    item.a_op=vif.a_op;
    item.b_op=vif.b_op;
    item.ALU_en=vif.ALU_en;
    item.a_en=vif.a_en;
    item.b_en=vif.b_en;
    item.rst_n=vif.rst_n;
    @(posedge vif.clk);
    item.C=vif.C;
    @(posedge vif.clk);
    mon2scb.put(item);
    mon2cov.put(item);
    item.print_info("Monitor");
    end
  endtask
  
endclass
