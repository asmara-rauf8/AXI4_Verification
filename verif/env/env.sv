class env extends uvm_env;
  `uvm_component_utils(env)

  env_cfg             cfg;
  master_proto_module master_pm;
  slave_proto_module  slave_pm;
  scoreboard          scb;

  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("ENV", "Unable to get env_cfg from config_db")
    end

    master_pm = master_proto_module::type_id::create("master_pm", this);
    slave_pm  = slave_proto_module::type_id::create("slave_pm", this);
    scb       = scoreboard::type_id::create("scb", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    slave_pm.vseqr.mem = cfg.mem;

    master_pm.aw_agent.monitor.analysis_port.connect(scb.master_aw_imp);
    slave_pm.aw_agent.monitor.analysis_port.connect(scb.slave_aw_imp);
    master_pm.w_agent.monitor.analysis_port.connect(scb.master_w_imp);
    slave_pm.w_agent.monitor.analysis_port.connect(scb.slave_w_imp);
    master_pm.ar_agent.monitor.analysis_port.connect(scb.master_ar_imp);
    slave_pm.ar_agent.monitor.analysis_port.connect(scb.slave_ar_imp);
    master_pm.b_agent.monitor.analysis_port.connect(scb.master_b_imp);
    slave_pm.b_agent.monitor.analysis_port.connect(scb.slave_b_imp);
    master_pm.r_agent.monitor.analysis_port.connect(scb.master_r_imp);
    slave_pm.r_agent.monitor.analysis_port.connect(scb.slave_r_imp);
  endfunction
endclass
