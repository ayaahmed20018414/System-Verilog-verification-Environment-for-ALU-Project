import ALU_pkg::*;
class Environment;
  virtual alu_interface vif;
  //object from each Environement component
  driver drv;
  monitor mon;
  scoreboard scb;
  generator gen;
  transaction item;
  coverpoints cov1;
  //mailboxes 
  mailbox gen2drv;
  mailbox mon2scb;
  mailbox mon2cov;

  function new(virtual alu_interface vif);
    this.vif=vif;
    //mailboxes creation 
    gen2drv=new();
    mon2scb=new();
    mon2cov=new();
    //components creation
    drv=new(vif,gen2drv);
    gen=new(gen2drv);
    scb=new(mon2scb);
    mon=new(vif,mon2scb,mon2cov);
    cov1=new(vif,mon2cov);
    
  endfunction 
  
  task pre_test();
    drv.reset;
  endtask
  task test();
    fork
      drv.main();
      gen.main();
      mon.main();
      scb.main();
      cov1.sample_covergroup();
    join
  endtask
  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_cnt==drv.no_transaction);
    wait(gen.repeat_cnt==scb.no_transactions);
  endtask 
  task run();
    pre_test();
    test();
    post_test();
  endtask
endclass
