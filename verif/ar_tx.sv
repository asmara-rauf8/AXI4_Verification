class ar_tx extends uvm_sequence_item;
  bit arready; 
  rand bit arvalid; 
  rand bit [WID - 1:0] arid; //constant for each transaction in burst
  rand bit [8-1:0] arlen;    // 1 to 256 transactions in single transfer
  rand bit [3-1:0] arsize;   //6 for narrow, 7 for full i.e, 2^7 bytes
  rand bit [2-1:0] arburst;  //burst type? fixed, incr, wrap
  rand bit [ADDR_WIDTH - 1:0] araddr;
  
  function new(string name = "ar_tx");
    super.new(name);
  endfunction
  
//length, burst, id, size values must be same of read and write. however valid must not be same
  `uvm_object_utils_begin(ar_tx)
  `uvm_field_int(arvalid, UVM_ALL_ON)
  `uvm_field_int(arid, UVM_ALL_ON)
  `uvm_field_int(arlen, UVM_ALL_ON)
  `uvm_field_int(arsize, UVM_ALL_ON)
  `uvm_field_int(arburst, UVM_ALL_ON)
  `uvm_field_int(araddr, UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass
