class r_slave_agent extends uvm_agent;
  `uvm_component_utils(r_slave_agent)

  r_sequencer sequencer;
  r_slave_driver driver;
  r_slave_monitor monitor;

  function new(string name = "r_slave_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = r_sequencer::type_id::create("sequencer", this);
    driver    = r_slave_driver::type_id::create("driver", this);
    monitor   = r_slave_monitor::type_id::create("monitor", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
endclass
