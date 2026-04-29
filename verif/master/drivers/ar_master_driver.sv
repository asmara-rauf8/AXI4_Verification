class ar_master_driver extends uvm_driver #(ar_tx);
  `uvm_component_utils(ar_master_driver)

  env_cfg cfg;
  virtual master_if vif;

  function new(string name = "ar_master_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("AR_M_DRV", "cfg missing")
    vif = cfg.master_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    ar_tx req;
    vif.drv_cb.arvalid <= 1'b0;
    forever begin
      seq_item_port.get_next_item(req);
      @(vif.drv_cb);
      vif.drv_cb.arid    <= req.arid;
      vif.drv_cb.araddr  <= req.araddr;
      vif.drv_cb.arlen   <= req.arlen;
      vif.drv_cb.arsize  <= req.arsize;
      vif.drv_cb.arburst <= req.arburst;
      vif.drv_cb.arvalid <= 1'b1;
      do @(vif.drv_cb); while (!vif.drv_cb.arready);
      vif.drv_cb.arvalid <= 1'b0;
      seq_item_port.item_done();
    end
  endtask
endclass
