class b_tx extends uvm_sequence_item;
  bit bready; 
  rand bit bvalid; 
  rand bit [WID - 1:0] bid; //constant for each transaction in burst
  rand bit [1:0] bresp;  //00: okay
  
  function new(string name = "b_tx");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(b_tx)
  `uvm_field_int(bvalid, UVM_ALL_ON)
  `uvm_field_int(bid, UVM_ALL_ON)
  `uvm_field_int(bresp, UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass
