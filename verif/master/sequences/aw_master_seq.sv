class aw_master_seq extends uvm_sequence #(aw_tx);
  `uvm_object_utils(aw_master_seq)

  rand bit [WID - 1:0]        awid;
  rand bit [ADDR_WIDTH - 1:0] awaddr;
  rand bit [7:0]              awlen;
  rand bit [2:0]              awsize;
  rand bit [1:0]              awburst;

  function new(string name = "aw_master_seq");
    super.new(name);
  endfunction

  virtual task body();
    aw_tx req;
    req = aw_tx::type_id::create("req");
    start_item(req);
    if (!req.randomize() with {
      awvalid == 1'b1;
      awid    == local::awid;
      awaddr  == local::awaddr;
      awlen   == local::awlen;
      awsize  == local::awsize;
      awburst == local::awburst;
    }) begin
      `uvm_fatal("AW_M_SEQ", "Failed to randomize AW request")
    end
    finish_item(req);
  endtask
endclass
