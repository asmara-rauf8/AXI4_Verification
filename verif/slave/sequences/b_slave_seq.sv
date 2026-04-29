class b_slave_seq extends uvm_sequence #(b_tx);
  `uvm_object_utils(b_slave_seq)

  bit [WID - 1:0] bid;
  bit [1:0]       bresp = RESP_OKAY;

  function new(string name = "b_slave_seq");
    super.new(name);
  endfunction

  virtual task body();
    b_tx req;
    req = b_tx::type_id::create("req");
    start_item(req);
    req.bid    = bid;
    req.bresp  = bresp;
    req.bvalid = 1'b1;
    finish_item(req);
  endtask
endclass
