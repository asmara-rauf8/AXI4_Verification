`uvm_analysis_imp_decl(_master_aw)
`uvm_analysis_imp_decl(_slave_aw)
`uvm_analysis_imp_decl(_master_w)
`uvm_analysis_imp_decl(_slave_w)
`uvm_analysis_imp_decl(_master_ar)
`uvm_analysis_imp_decl(_slave_ar)
`uvm_analysis_imp_decl(_master_b)
`uvm_analysis_imp_decl(_slave_b)
`uvm_analysis_imp_decl(_master_r)
`uvm_analysis_imp_decl(_slave_r)

class scoreboard extends uvm_component;
  `uvm_component_utils(scoreboard)

  env_cfg cfg;

  uvm_analysis_imp_master_aw #(aw_tx, scoreboard) master_aw_imp;
  uvm_analysis_imp_slave_aw  #(aw_tx, scoreboard) slave_aw_imp;
  uvm_analysis_imp_master_w  #(w_tx, scoreboard)  master_w_imp;
  uvm_analysis_imp_slave_w   #(w_tx, scoreboard)  slave_w_imp;
  uvm_analysis_imp_master_ar #(ar_tx, scoreboard) master_ar_imp;
  uvm_analysis_imp_slave_ar  #(ar_tx, scoreboard) slave_ar_imp;
  uvm_analysis_imp_master_b  #(b_tx, scoreboard)  master_b_imp;
  uvm_analysis_imp_slave_b   #(b_tx, scoreboard)  slave_b_imp;
  uvm_analysis_imp_master_r  #(r_tx, scoreboard)  master_r_imp;
  uvm_analysis_imp_slave_r   #(r_tx, scoreboard)  slave_r_imp;

  aw_tx master_aw_by_id[int unsigned];
  aw_tx slave_aw_by_id[int unsigned];
  ar_tx master_ar_by_id[int unsigned];
  ar_tx slave_ar_by_id[int unsigned];
  b_tx  slave_b_by_id[int unsigned];

  w_tx master_w_by_id[int unsigned][$];
  w_tx slave_w_by_id[int unsigned][$];
  r_tx slave_r_by_id[int unsigned][$];
  int unsigned read_beat_count[int unsigned];

  bit [1:0] sampled_awburst;
  bit [2:0] sampled_awsize;
  bit [7:0] sampled_awlen;
  bit [1:0] sampled_arburst;
  bit [2:0] sampled_arsize;
  bit [7:0] sampled_arlen;

  covergroup aw_cg;
    option.per_instance = 1;
    cp_burst : coverpoint sampled_awburst { bins fixed = {BURST_FIXED}; bins incr = {BURST_INCR}; bins wrap = {BURST_WRAP}; }
    cp_size  : coverpoint sampled_awsize  { bins sizes[] = {[0:$clog2(DATA_WIDTH/8)]}; }
    cp_len   : coverpoint sampled_awlen   { bins single = {0}; bins short_len = {[1:15]}; bins medium_len = {[16:63]}; bins long_len = {[64:255]}; }
    cross_burst_size_len : cross cp_burst, cp_size, cp_len;
  endgroup

  covergroup ar_cg;
    option.per_instance = 1;
    cp_burst : coverpoint sampled_arburst { bins fixed = {BURST_FIXED}; bins incr = {BURST_INCR}; bins wrap = {BURST_WRAP}; }
    cp_size  : coverpoint sampled_arsize  { bins sizes[] = {[0:$clog2(DATA_WIDTH/8)]}; }
    cp_len   : coverpoint sampled_arlen   { bins single = {0}; bins short_len = {[1:15]}; bins medium_len = {[16:63]}; bins long_len = {[64:255]}; }
    cross_burst_size_len : cross cp_burst, cp_size, cp_len;
  endgroup

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
    master_aw_imp = new("master_aw_imp", this);
    slave_aw_imp  = new("slave_aw_imp", this);
    master_w_imp  = new("master_w_imp", this);
    slave_w_imp   = new("slave_w_imp", this);
    master_ar_imp = new("master_ar_imp", this);
    slave_ar_imp  = new("slave_ar_imp", this);
    master_b_imp  = new("master_b_imp", this);
    slave_b_imp   = new("slave_b_imp", this);
    master_r_imp  = new("master_r_imp", this);
    slave_r_imp   = new("slave_r_imp", this);
    aw_cg = new();
    ar_cg = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("SCB", "Unable to get env_cfg from config_db")
    end
  endfunction

  function void write_master_aw(aw_tx t);
    master_aw_by_id[t.awid] = t;
    sampled_awburst = t.awburst;
    sampled_awsize  = t.awsize;
    sampled_awlen   = t.awlen;
    aw_cg.sample();
  endfunction

  function void write_slave_aw(aw_tx t);
    slave_aw_by_id[t.awid] = t;
    if (!master_aw_by_id.exists(t.awid)) begin
      `uvm_error("SCB_AW", $sformatf("Slave observed AWID %0d before master scoreboard entry", t.awid))
    end else if (!t.compare(master_aw_by_id[t.awid])) begin
      `uvm_error("SCB_AW", $sformatf("Master/slave AW mismatch for ID %0d", t.awid))
    end
  endfunction

  function void write_master_w(w_tx t);
    master_w_by_id[t.wid].push_back(t);
  endfunction

  function void write_slave_w(w_tx t);
    w_tx exp;
    int unsigned beat_idx;
    bit [ADDR_WIDTH - 1:0] curr_beat_addr;

    slave_w_by_id[t.wid].push_back(t);
    if (master_w_by_id.exists(t.wid) && master_w_by_id[t.wid].size() != 0) begin
      exp = master_w_by_id[t.wid].pop_front();
      if (!t.compare(exp)) begin
        `uvm_error("SCB_W", $sformatf("Master/slave W beat mismatch for ID %0d", t.wid))
      end
    end

    if (master_aw_by_id.exists(t.wid)) begin
      beat_idx       = slave_w_by_id[t.wid].size() - 1;
      curr_beat_addr = beat_addr(master_aw_by_id[t.wid].awaddr,
                                 master_aw_by_id[t.wid].awlen,
                                 master_aw_by_id[t.wid].awsize,
                                 master_aw_by_id[t.wid].awburst,
                                 beat_idx);
      cfg.mem.write_word(curr_beat_addr, t.wdata, t.wstrb);
    end
  endfunction

  function void write_master_ar(ar_tx t);
    master_ar_by_id[t.arid]  = t;
    read_beat_count[t.arid]  = 0;
    sampled_arburst          = t.arburst;
    sampled_arsize           = t.arsize;
    sampled_arlen            = t.arlen;
    ar_cg.sample();
  endfunction

  function void write_slave_ar(ar_tx t);
    slave_ar_by_id[t.arid] = t;
    if (!master_ar_by_id.exists(t.arid)) begin
      `uvm_error("SCB_AR", $sformatf("Slave observed ARID %0d before master scoreboard entry", t.arid))
    end else if (!t.compare(master_ar_by_id[t.arid])) begin
      `uvm_error("SCB_AR", $sformatf("Master/slave AR mismatch for ID %0d", t.arid))
    end
  endfunction

  function void write_slave_b(b_tx t);
    slave_b_by_id[t.bid] = t;
  endfunction

  function void write_master_b(b_tx t);
    if (!master_aw_by_id.exists(t.bid)) begin
      `uvm_error("SCB_B", $sformatf("Unexpected B response for BID %0d", t.bid))
      return;
    end
    if (slave_b_by_id.exists(t.bid) && !t.compare(slave_b_by_id[t.bid])) begin
      `uvm_error("SCB_B", $sformatf("Master/slave B mismatch for BID %0d", t.bid))
    end
    master_aw_by_id.delete(t.bid);
    slave_aw_by_id.delete(t.bid);
    master_w_by_id.delete(t.bid);
    slave_w_by_id.delete(t.bid);
    slave_b_by_id.delete(t.bid);
  endfunction

  function void write_slave_r(r_tx t);
    slave_r_by_id[t.rid].push_back(t);
  endfunction

  function void write_master_r(r_tx t);
    bit [ADDR_WIDTH - 1:0] curr_beat_addr;
    bit [DATA_WIDTH - 1:0] exp_data;
    int unsigned beat_idx;
    r_tx exp;

    if (!master_ar_by_id.exists(t.rid)) begin
      `uvm_error("SCB_R", $sformatf("Unexpected R response for RID %0d", t.rid))
      return;
    end

    beat_idx       = read_beat_count[t.rid];
    curr_beat_addr = beat_addr(master_ar_by_id[t.rid].araddr,
                               master_ar_by_id[t.rid].arlen,
                               master_ar_by_id[t.rid].arsize,
                               master_ar_by_id[t.rid].arburst,
                               beat_idx);
    exp_data = cfg.mem.read_word(curr_beat_addr);

    if (t.rdata !== exp_data) begin
      `uvm_error("SCB_R", $sformatf("RDATA mismatch for RID %0d beat %0d exp=%0h act=%0h", t.rid, beat_idx, exp_data, t.rdata))
    end

    if (slave_r_by_id.exists(t.rid) && slave_r_by_id[t.rid].size() != 0) begin
      exp = slave_r_by_id[t.rid].pop_front();
      if (!t.compare(exp)) begin
        `uvm_error("SCB_R", $sformatf("Master/slave R mismatch for RID %0d beat %0d", t.rid, beat_idx))
      end
    end

    read_beat_count[t.rid]++;
    if (t.rlast) begin
      if (beat_idx != master_ar_by_id[t.rid].arlen) begin
        `uvm_error("SCB_R", $sformatf("RLAST asserted on beat %0d but expected beat %0d for RID %0d",
                   beat_idx, master_ar_by_id[t.rid].arlen, t.rid))
      end
      master_ar_by_id.delete(t.rid);
      slave_ar_by_id.delete(t.rid);
      slave_r_by_id.delete(t.rid);
      read_beat_count.delete(t.rid);
    end
  endfunction
endclass
