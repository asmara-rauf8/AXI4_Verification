class r_tx extends uvm_sequence_item;
  bit rready; 
  rand bit rvalid; 
  rand bit [rid - 1:0] rid; //constant for each transaction in burst
  rand bit rlast;           //last write data
  rand bit [DATA_ridTH - 1:0] rdata;
  //rand bit [DATA_ridTH/8 - 1:0] rstrb;  //which byte lane of read channel contains valid data
  rand bit rresp;
  
  function new(string name = "r_tx");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(r_tx)
  `uvm_field_int(rvalid, UVM_ALL_ON)
  `uvm_field_int(rid, UVM_ALL_ON)
  `uvm_field_int(rlast, UVM_ALL_ON)
  `uvm_field_int(rdata, UVM_ALL_ON)
  //`uvm_field_int(rstrb, UVM_ALL_ON)
  `uvm_field_int(rresp, UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass
