class coverpoints;
virtual alu_interface vif;
transaction item;
mailbox mon2cov;
function new(virtual alu_interface vif, mailbox mon2cov);
	cg=new();
	this.vif=vif; 	
	this.mon2cov=mon2cov;
endfunction


covergroup cg;
coverpoint item.A {bins bin_0 ={0};
bins bin_max_val ={15};
bins bin_min_val ={-15};
bins bin_all_values ={[-14:14]};
}
coverpoint item.B {bins bin_0 ={0};
bins bin_max_val ={15};
bins bin_min_val ={-15};
bins bin_all_values ={[-14:14]};
}
coverpoint item.a_op;
coverpoint item.b_op;
cross item.A,item.B;
cross item.a_en,item.b_en;
endgroup

task sample_covergroup();
	forever begin
	 	mon2cov.get(item);
		@(posedge vif.clk) cg.sample();
	end


endtask

endclass
