class w_tx extends uvm_sequence_item;
  bit wready;
  rand bit wvalid;
  rand bit [WID - 1:0] wid;
  rand bit wlast;
  rand bit [DATA_WIDTH - 1:0] wdata;
  rand bit [DATA_WIDTH/8 - 1:0] wstrb;

  function new(string name = "w_tx");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(w_tx)
    `uvm_field_int(wvalid, UVM_ALL_ON)
    `uvm_field_int(wready, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_int(wid, UVM_ALL_ON)
    `uvm_field_int(wlast, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(wstrb, UVM_ALL_ON)
  `uvm_object_utils_end
endclass
