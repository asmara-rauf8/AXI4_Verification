class master_vseq extends uvm_sequence;
  `uvm_object_utils(master_vseq)
  `uvm_declare_p_sequencer(master_virtual_sequencer)

  typedef struct {
    bit [WID - 1:0]        id;
    bit [ADDR_WIDTH - 1:0] addr;
    bit [7:0]              len;
    bit [2:0]              size;
    bit [1:0]              burst;
  } burst_cfg_s;

  int unsigned num_wr_txns = 4;
  int unsigned num_rd_txns = 4;
  bit [ADDR_WIDTH - 1:0] base_addr = 'h1000;
  bit [7:0]              txn_len   = 8'd0;
  bit [2:0]              txn_size  = 3'd2;
  bit [1:0]              txn_burst = BURST_INCR;
  burst_cfg_s   write_history[$];

  function new(string name = "master_vseq");
    super.new(name);
  endfunction

  constraint c_vseq_cfg {
    txn_size <= $clog2(DATA_WIDTH/8);
    base_addr % (1 << txn_size) == 0;
    if (txn_burst == BURST_WRAP) {
      txn_len inside {8'd1, 8'd3, 8'd7, 8'd15};
      base_addr % (num_beats(txn_len) * bytes_per_beat(txn_size)) == 0;
    }
  }

  protected function void check_cfg();
    if (txn_size > $clog2(DATA_WIDTH/8)) begin
      `uvm_fatal("MST_VSEQ", "txn_size exceeds interface capability")
    end
    if (base_addr % (1 << txn_size) != 0) begin
      `uvm_fatal("MST_VSEQ", "base_addr is not aligned to txn_size")
    end
    if ((txn_burst == BURST_WRAP) &&
        !(txn_len inside {8'd1, 8'd3, 8'd7, 8'd15})) begin
      `uvm_fatal("MST_VSEQ", "WRAP burst requires len of 1, 3, 7, or 15")
    end
  endfunction

  protected function burst_cfg_s build_write_cfg(int unsigned txn_idx);
    burst_cfg_s cfg_s;
    cfg_s.id    = txn_idx[WID-1:0];
    cfg_s.size  = txn_size;
    cfg_s.burst = txn_burst;
    cfg_s.len   = txn_len;
    cfg_s.addr  = base_addr + (txn_idx * num_beats(txn_len) * bytes_per_beat(txn_size));
    return cfg_s;
  endfunction

  protected task start_write_txn(burst_cfg_s cfg_s);
    aw_master_seq aw_seq;
    w_master_seq  w_seq;

    aw_seq = aw_master_seq::type_id::create($sformatf("aw_seq_%0d", cfg_s.id));
    aw_seq.awid    = cfg_s.id;
    aw_seq.awaddr  = cfg_s.addr;
    aw_seq.awlen   = cfg_s.len;
    aw_seq.awsize  = cfg_s.size;
    aw_seq.awburst = cfg_s.burst;
    aw_seq.start(p_sequencer.aw_sqr);

    w_seq = w_master_seq::type_id::create($sformatf("w_seq_%0d", cfg_s.id));
    w_seq.wid       = cfg_s.id;
    w_seq.base_addr = cfg_s.addr;
    w_seq.awlen     = cfg_s.len;
    w_seq.awsize    = cfg_s.size;
    w_seq.awburst   = cfg_s.burst;
    w_seq.start(p_sequencer.w_sqr);
  endtask

  protected task start_read_txn(int unsigned txn_idx, burst_cfg_s cfg_s);
    ar_master_seq ar_seq;

    ar_seq = ar_master_seq::type_id::create($sformatf("ar_seq_%0d", txn_idx));
    ar_seq.arid    = txn_idx[WID-1:0];
    ar_seq.araddr  = cfg_s.addr;
    ar_seq.arlen   = cfg_s.len;
    ar_seq.arsize  = cfg_s.size;
    ar_seq.arburst = cfg_s.burst;
    ar_seq.start(p_sequencer.ar_sqr);
  endtask

  virtual task body();
    burst_cfg_s cfg_s;
    check_cfg();
    write_history.delete();

    for (int unsigned i = 0; i < num_wr_txns; i++) begin
      cfg_s = build_write_cfg(i);
      write_history.push_back(cfg_s);
      start_write_txn(cfg_s);
    end

    for (int unsigned i = 0; i < num_rd_txns; i++) begin
      if (write_history.size() == 0) begin
        `uvm_fatal("MST_VSEQ", "No write history available to generate matching read transactions")
      end
      cfg_s = write_history[i % write_history.size()];
      start_read_txn(i + 32, cfg_s);
    end
  endtask
endclass
