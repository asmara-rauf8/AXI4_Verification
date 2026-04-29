class ar_master_seq extends uvm_sequence #(ar_tx);
  `uvm_object_utils(ar_master_seq)

  rand bit [WID - 1:0]        arid;
  rand bit [ADDR_WIDTH - 1:0] araddr;
  rand bit [7:0]              arlen;
  rand bit [2:0]              arsize;
  rand bit [1:0]              arburst;

  function new(string name = "ar_master_seq");
    super.new(name);
  endfunction

  virtual task body();
    ar_tx req;
    req = ar_tx::type_id::create("req");
    start_item(req);
    if (!req.randomize() with {
      arvalid == 1'b1;
      arid    == local::arid;
      araddr  == local::araddr;
      arlen   == local::arlen;
      arsize  == local::arsize;
      arburst == local::arburst;
    }) begin
      `uvm_fatal("AR_M_SEQ", "Failed to randomize AR request")
    end
    finish_item(req);
  endtask
endclass
