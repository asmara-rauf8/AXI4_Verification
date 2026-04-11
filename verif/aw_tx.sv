class aw_tx extends uvm_sequence_item;
  bit awready; 
  rand bit awvalid; 
  rand bit [WID - 1:0] awid; //constant for each transaction in burst
  rand bit [8-1:0] awlen;    // 1 to 256 transactions in single transfer
  rand bit [3-1:0] awsize;   //6 for narrow, 7 for full i.e, 2^7 bytes
  rand bit [2-1:0] awburst;  //burst type? fixed, incr, wrap
  rand bit [ADDR_WIDTH - 1:0] awaddr;
  
  function new(string name = "aw_tx");
    super.new(name);
  endfunction
  
//length, burst, id, size values must be same of read and write. however valid must not be same
  `uvm_object_utils_begin(aw_tx)
  `uvm_field_int(awvalid, UVM_ALL_ON)
  `uvm_field_int(awid, UVM_ALL_ON)
  `uvm_field_int(awlen, UVM_ALL_ON)
  `uvm_field_int(awsize, UVM_ALL_ON)
  `uvm_field_int(awburst, UVM_ALL_ON)
  `uvm_field_int(awaddr, UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass
