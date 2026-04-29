class ar_slave_driver extends uvm_component;
  `uvm_component_utils(ar_slave_driver)

  env_cfg cfg;
  virtual slave_if vif;

  function new(string name = "ar_slave_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("AR_S_DRV", "cfg missing")
    vif = cfg.slave_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(vif.drv_cb);
      vif.drv_cb.arready <= vif.rst_n;
    end
  endtask
endclass
