class ar_slave_agent extends uvm_agent;
  `uvm_component_utils(ar_slave_agent)

  ar_slave_driver driver;
  ar_slave_monitor monitor;

  function new(string name = "ar_slave_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver  = ar_slave_driver::type_id::create("driver", this);
    monitor = ar_slave_monitor::type_id::create("monitor", this);
  endfunction
endclass
