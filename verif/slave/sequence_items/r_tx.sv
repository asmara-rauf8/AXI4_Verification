class r_tx extends uvm_sequence_item;
  bit rready;
  rand bit rvalid;
  rand bit [RID - 1:0] rid;
  rand bit rlast;
  rand bit [DATA_WIDTH - 1:0] rdata;
  rand bit [1:0] rresp;

  function new(string name = "r_tx");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(r_tx)
    `uvm_field_int(rvalid, UVM_ALL_ON)
    `uvm_field_int(rready, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_int(rid, UVM_ALL_ON)
    `uvm_field_int(rlast, UVM_ALL_ON)
    `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_field_int(rresp, UVM_ALL_ON)
  `uvm_object_utils_end
endclass
