class ar_tx extends uvm_sequence_item;
  bit arready;
  rand bit arvalid;
  rand bit [WID - 1:0] arid;
  rand bit [8-1:0] arlen;
  rand bit [3-1:0] arsize;
  rand bit [2-1:0] arburst;
  rand bit [ADDR_WIDTH - 1:0] araddr;

  constraint c_arsize {
    arsize <= $clog2(DATA_WIDTH/8);
  }

  constraint c_araddr_align {
    araddr % (1 << arsize) == 0;
  }

  constraint c_arburst {
    if (arburst == BURST_WRAP) {
      arlen inside {8'd1, 8'd3, 8'd7, 8'd15};
      araddr % (num_beats(arlen) * bytes_per_beat(arsize)) == 0;
    }
  }

  function new(string name = "ar_tx");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(ar_tx)
    `uvm_field_int(arvalid, UVM_ALL_ON)
    `uvm_field_int(arready, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_int(arid, UVM_ALL_ON)
    `uvm_field_int(arlen, UVM_ALL_ON)
    `uvm_field_int(arsize, UVM_ALL_ON)
    `uvm_field_int(arburst, UVM_ALL_ON)
    `uvm_field_int(araddr, UVM_ALL_ON)
  `uvm_object_utils_end
endclass
