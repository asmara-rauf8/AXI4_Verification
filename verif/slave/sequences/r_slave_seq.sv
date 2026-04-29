class r_slave_seq extends uvm_sequence #(r_tx);
  `uvm_object_utils(r_slave_seq)

  bit [RID - 1:0]        rid;
  bit [ADDR_WIDTH - 1:0] base_addr;
  bit [7:0]              arlen;
  bit [2:0]              arsize;
  bit [1:0]              arburst;
  bit [1:0]              rresp = RESP_OKAY;
  mem_model              mem;

  function new(string name = "r_slave_seq");
    super.new(name);
  endfunction

  virtual task body();
    r_tx req;
    bit [ADDR_WIDTH - 1:0] curr_beat_addr;

    for (int beat = 0; beat < num_beats(arlen); beat++) begin
      req = r_tx::type_id::create($sformatf("req_%0d", beat));
      curr_beat_addr = beat_addr(base_addr, arlen, arsize, arburst, beat);
      start_item(req);
      req.rid    = rid;
      req.rdata  = mem.read_word(curr_beat_addr);
      req.rresp  = rresp;
      req.rlast  = (beat == num_beats(arlen) - 1);
      req.rvalid = 1'b1;
      finish_item(req);
    end
  endtask
endclass
