class w_master_driver extends uvm_driver #(w_tx);
  `uvm_component_utils(w_master_driver)

  env_cfg cfg;
  virtual master_if vif;

  function new(string name = "w_master_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("W_M_DRV", "cfg missing")
    vif = cfg.master_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    w_tx req;
    vif.drv_cb.wvalid <= 1'b0;
    forever begin
      seq_item_port.get_next_item(req);
      @(vif.drv_cb);
      vif.drv_cb.wid    <= req.wid;
      vif.drv_cb.wdata  <= req.wdata;
      vif.drv_cb.wstrb  <= req.wstrb;
      vif.drv_cb.wlast  <= req.wlast;
      vif.drv_cb.wvalid <= 1'b1;
      do @(vif.drv_cb); while (!vif.drv_cb.wready);
      vif.drv_cb.wvalid <= 1'b0;
      vif.drv_cb.wlast  <= 1'b0;
      seq_item_port.item_done();
    end
  endtask
endclass
