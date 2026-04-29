class master_proto_module extends uvm_env;
  `uvm_component_utils(master_proto_module)

  aw_master_agent aw_agent;
  w_master_agent  w_agent;
  ar_master_agent ar_agent;
  b_master_agent  b_agent;
  r_master_agent  r_agent;
  master_virtual_sequencer vseqr;

  function new(string name = "master_proto_module", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    aw_agent = aw_master_agent::type_id::create("aw_agent", this);
    w_agent  = w_master_agent::type_id::create("w_agent", this);
    ar_agent = ar_master_agent::type_id::create("ar_agent", this);
    b_agent  = b_master_agent::type_id::create("b_agent", this);
    r_agent  = r_master_agent::type_id::create("r_agent", this);
    vseqr    = master_virtual_sequencer::type_id::create("vseqr", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vseqr.aw_sqr = aw_agent.sequencer;
    vseqr.w_sqr  = w_agent.sequencer;
    vseqr.ar_sqr = ar_agent.sequencer;
  endfunction
endclass
