class r_master_agent extends uvm_agent;
  `uvm_component_utils(r_master_agent)

  r_master_driver driver;
  r_master_monitor monitor;

  function new(string name = "r_master_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver  = r_master_driver::type_id::create("driver", this);
    monitor = r_master_monitor::type_id::create("monitor", this);
  endfunction
endclass
