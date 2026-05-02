class env extends uvm_env;
  `uvm_component_utils(env)

  env_cfg    cfg;
  aw_master_agent aw_agent;
  w_master_agent  w_agent;
  ar_master_agent ar_agent;
  b_master_agent  b_agent;
  r_master_agent  r_agent;
  master_virtual_sequencer vseqr;

  aw_slave_agent aw_s_agent;
  w_slave_agent  w_s_agent;
  ar_slave_agent ar_s_agent;
  b_slave_agent  b_s_agent;
  r_slave_agent  r_s_agent;
  slave_virtual_sequencer vseqr_s;

  scoreboard scb;

  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("ENV", "Unable to get env_cfg from config_db")
    end

    aw_agent = aw_master_agent::type_id::create("aw_agent", this);
    w_agent  = w_master_agent::type_id::create("w_agent", this);
    ar_agent = ar_master_agent::type_id::create("ar_agent", this);
    b_agent  = b_master_agent::type_id::create("b_agent", this);
    r_agent  = r_master_agent::type_id::create("r_agent", this);
    vseqr    = master_virtual_sequencer::type_id::create("vseqr", this);

    aw_s_agent = aw_slave_agent::type_id::create("aw_s_agent", this);
    w_s_agent  = w_slave_agent::type_id::create("w_s_agent", this);
    ar_s_agent = ar_slave_agent::type_id::create("ar_s_agent", this);
    b_s_agent  = b_slave_agent::type_id::create("b_s_agent", this);
    r_s_agent  = r_slave_agent::type_id::create("r_s_agent", this);
    vseqr_s    = slave_virtual_sequencer::type_id::create("vseqr_s", this);

    scb = scoreboard::type_id::create("scb", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    vseqr_s.mem = cfg.mem;

    aw_agent.monitor.analysis_port.connect(scb.master_aw_imp);
    w_agent.monitor.analysis_port.connect(scb.master_w_imp);
    ar_agent.monitor.analysis_port.connect(scb.master_ar_imp);
    b_agent.monitor.analysis_port.connect(scb.master_b_imp);
    r_agent.monitor.analysis_port.connect(scb.master_r_imp);

    aw_s_agent.monitor.analysis_port.connect(scb.slave_aw_imp);
    w_s_agent.monitor.analysis_port.connect(scb.slave_w_imp);
    ar_s_agent.monitor.analysis_port.connect(scb.slave_ar_imp);
    b_s_agent.monitor.analysis_port.connect(scb.slave_b_imp);
    r_s_agent.monitor.analysis_port.connect(scb.slave_r_imp);
  endfunction
endclass
