class slave_proto_module extends uvm_env;
  `uvm_component_utils(slave_proto_module)

  aw_slave_agent aw_agent;
  w_slave_agent  w_agent;
  ar_slave_agent ar_agent;
  b_slave_agent  b_agent;
  r_slave_agent  r_agent;
  slave_virtual_sequencer vseqr;

  function new(string name = "slave_proto_module", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    aw_agent = aw_slave_agent::type_id::create("aw_agent", this);
    w_agent  = w_slave_agent::type_id::create("w_agent", this);
    ar_agent = ar_slave_agent::type_id::create("ar_agent", this);
    b_agent  = b_slave_agent::type_id::create("b_agent", this);
    r_agent  = r_slave_agent::type_id::create("r_agent", this);
    vseqr    = slave_virtual_sequencer::type_id::create("vseqr", this);

    vseqr.aw_fifo = new("aw_fifo", this);
    vseqr.w_fifo  = new("w_fifo", this);
    vseqr.ar_fifo = new("ar_fifo", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vseqr.b_sqr  = b_agent.sequencer;
    vseqr.r_sqr  = r_agent.sequencer;
    aw_agent.monitor.analysis_port.connect(vseqr.aw_fifo.analysis_export);
    w_agent.monitor.analysis_port.connect(vseqr.w_fifo.analysis_export);
    ar_agent.monitor.analysis_port.connect(vseqr.ar_fifo.analysis_export);
  endfunction
endclass
