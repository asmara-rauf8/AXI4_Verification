class w_master_seq extends uvm_sequence #(w_tx);
  `uvm_object_utils(w_master_seq)

  rand bit [WID - 1:0]        wid;
  rand bit [ADDR_WIDTH - 1:0] base_addr;
  rand bit [7:0]              awlen;
  rand bit [2:0]              awsize;
  rand bit [1:0]              awburst;

  function new(string name = "w_master_seq");
    super.new(name);
  endfunction

  virtual task body();
    w_tx req;
    bit [ADDR_WIDTH - 1:0] curr_beat_addr;

    for (int beat = 0; beat < num_beats(awlen); beat++) begin
      req = w_tx::type_id::create($sformatf("req_%0d", beat));
      curr_beat_addr = beat_addr(base_addr, awlen, awsize, awburst, beat);
      start_item(req);
      if (!req.randomize() with { wid == local::wid; wvalid == 1'b1; }) begin
        `uvm_fatal("W_M_SEQ", "Failed to randomize W request")
      end
      req.wlast = (beat == num_beats(awlen) - 1);
      req.wstrb = compute_strb(awsize, curr_beat_addr);
      finish_item(req);
    end
  endtask
endclass
