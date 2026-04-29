class aw_tx extends uvm_sequence_item;
  bit awready;
  rand bit awvalid;
  rand bit [WID - 1:0] awid;
  rand bit [8-1:0] awlen;
  rand bit [3-1:0] awsize;
  rand bit [2-1:0] awburst;
  rand bit [ADDR_WIDTH - 1:0] awaddr;

  constraint c_awsize {
    awsize <= $clog2(DATA_WIDTH/8);
  }

  constraint c_awaddr_align {
    awaddr % (1 << awsize) == 0;
  }

  constraint c_awburst {
    if (awburst == BURST_WRAP) {
      awlen inside {8'd1, 8'd3, 8'd7, 8'd15};
      awaddr % (num_beats(awlen) * bytes_per_beat(awsize)) == 0;
    }
  }

  function new(string name = "aw_tx");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(aw_tx)
    `uvm_field_int(awvalid, UVM_ALL_ON)
    `uvm_field_int(awready, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_int(awid, UVM_ALL_ON)
    `uvm_field_int(awlen, UVM_ALL_ON)
    `uvm_field_int(awsize, UVM_ALL_ON)
    `uvm_field_int(awburst, UVM_ALL_ON)
    `uvm_field_int(awaddr, UVM_ALL_ON)
  `uvm_object_utils_end
endclass
