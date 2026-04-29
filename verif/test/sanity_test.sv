class sanity_test extends uvm_test;
  `uvm_component_utils(sanity_test)

  env     env_h;
  env_cfg cfg;

  function new(string name = "sanity_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    string tb_mode_arg;

    super.build_phase(phase);
    cfg = env_cfg::type_id::create("cfg");
    if (!uvm_config_db#(virtual master_if)::get(null, "uvm_test_top", "master_vif", cfg.master_vif)) begin
      `uvm_fatal("TEST", "master_vif not found in config_db")
    end
    if (!uvm_config_db#(virtual slave_if)::get(null, "uvm_test_top", "slave_vif", cfg.slave_vif)) begin
      `uvm_fatal("TEST", "slave_vif not found in config_db")
    end

    cfg.mem = mem_model::type_id::create("mem");
    if ($value$plusargs("TB_MODE=%s", tb_mode_arg) && tb_mode_arg == "LOOPBACK") begin
      cfg.tb_mode = TB_MODE_LOOPBACK;
    end else begin
      cfg.tb_mode = TB_MODE_B2B;
    end

    uvm_config_db#(env_cfg)::set(this, "*", "cfg", cfg);
    env_h = env::type_id::create("env_h", this);
  endfunction

  virtual task do_setup(master_vseq master_vseq_h, slave_vseq slave_vseq_h);
    master_vseq_h.num_wr_txns = 4;
    master_vseq_h.num_rd_txns = 4;
    master_vseq_h.base_addr   = 'h1000;
    master_vseq_h.txn_len     = 8'd0;
    master_vseq_h.txn_size    = 3'd2;
    master_vseq_h.txn_burst   = BURST_INCR;
  endtask

  virtual task run_phase(uvm_phase phase);
    master_vseq master_vseq_h;
    slave_vseq  slave_vseq_h;

    super.run_phase(phase);
    phase.raise_objection(this);

    master_vseq_h = master_vseq::type_id::create("master_vseq_h");
    slave_vseq_h  = slave_vseq::type_id::create("slave_vseq_h");
    do_setup(master_vseq_h, slave_vseq_h);

    fork
      slave_vseq_h.start(env_h.slave_pm.vseqr);
    join_none

    master_vseq_h.start(env_h.master_pm.vseqr);
    repeat (20) @(posedge cfg.master_vif.clk);
    phase.drop_objection(this);
  endtask
endclass
