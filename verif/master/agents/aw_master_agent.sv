class aw_master_agent extends uvm_agent;
  `uvm_component_utils(aw_master_agent)

  aw_sequencer sequencer;
  aw_master_driver driver;
  aw_master_monitor monitor;

  function new(string name = "aw_master_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = aw_sequencer::type_id::create("sequencer", this);
    driver    = aw_master_driver::type_id::create("driver", this);
    monitor   = aw_master_monitor::type_id::create("monitor", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
endclass
