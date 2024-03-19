class generator;
  transaction item;
  mailbox gen2drv;
  event ended;
  int repeat_cnt;
  function new(mailbox gen2drv);
    this.gen2drv=gen2drv;
  endfunction
  //generator main task to generate stimulus that will be applied to dut 
  task main();
    repeat(repeat_cnt) begin
      item=new();
      if(!item.randomize) $fatal("randomization can't be done");
      gen2drv.put(item);
    end
     ->ended;
  endtask 
  
endclass 
