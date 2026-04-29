class aw_slave_agent extends uvm_agent;
  `uvm_component_utils(aw_slave_agent)

  aw_slave_driver driver;
  aw_slave_monitor monitor;

  function new(string name = "aw_slave_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver  = aw_slave_driver::type_id::create("driver", this);
    monitor = aw_slave_monitor::type_id::create("monitor", this);
  endfunction
endclass
