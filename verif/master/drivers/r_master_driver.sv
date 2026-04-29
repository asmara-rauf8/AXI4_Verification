class r_master_driver extends uvm_component;
  `uvm_component_utils(r_master_driver)

  env_cfg cfg;
  virtual master_if vif;

  function new(string name = "r_master_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("R_M_DRV", "cfg missing")
    vif = cfg.master_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(vif.drv_cb);
      vif.drv_cb.rready <= vif.rst_n;
    end
  endtask
endclass
