class b_master_agent extends uvm_agent;
  `uvm_component_utils(b_master_agent)

  b_master_driver driver;
  b_master_monitor monitor;

  function new(string name = "b_master_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver  = b_master_driver::type_id::create("driver", this);
    monitor = b_master_monitor::type_id::create("monitor", this);
  endfunction
endclass
