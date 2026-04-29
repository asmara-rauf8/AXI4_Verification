class slave_vseq extends uvm_sequence;
  `uvm_object_utils(slave_vseq)
  `uvm_declare_p_sequencer(slave_virtual_sequencer)

  function new(string name = "slave_vseq");
    super.new(name);
  endfunction

  protected task handle_writes();
    aw_tx aw_req;
    w_tx  w_req;
    b_slave_seq b_seq;
    bit [ADDR_WIDTH - 1:0] curr_beat_addr;

    forever begin
      p_sequencer.aw_fifo.get(aw_req);
      for (int beat = 0; beat < num_beats(aw_req.awlen); beat++) begin
        p_sequencer.w_fifo.get(w_req);
        curr_beat_addr = beat_addr(aw_req.awaddr, aw_req.awlen, aw_req.awsize, aw_req.awburst, beat);
        p_sequencer.mem.write_word(curr_beat_addr, w_req.wdata, w_req.wstrb);
        if ((beat == num_beats(aw_req.awlen) - 1) && !w_req.wlast) begin
          `uvm_error("SLV_VSEQ", "WLAST was not asserted on final write beat")
        end
      end

      b_seq = b_slave_seq::type_id::create($sformatf("b_seq_%0d", aw_req.awid));
      b_seq.bid   = aw_req.awid;
      b_seq.bresp = RESP_OKAY;
      b_seq.start(p_sequencer.b_sqr);
    end
  endtask

  protected task handle_reads();
    ar_tx ar_req;
    r_slave_seq r_seq;

    forever begin
      p_sequencer.ar_fifo.get(ar_req);
      r_seq = r_slave_seq::type_id::create($sformatf("r_seq_%0d", ar_req.arid));
      r_seq.rid       = ar_req.arid;
      r_seq.base_addr = ar_req.araddr;
      r_seq.arlen     = ar_req.arlen;
      r_seq.arsize    = ar_req.arsize;
      r_seq.arburst   = ar_req.arburst;
      r_seq.mem       = p_sequencer.mem;
      r_seq.start(p_sequencer.r_sqr);
    end
  endtask

  virtual task body();
    fork
      handle_writes();
      handle_reads();
    join
  endtask
endclass
