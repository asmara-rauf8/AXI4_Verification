class aw_master_driver extends uvm_driver #(aw_tx);
  `uvm_component_utils(aw_master_driver)

  env_cfg cfg;
  virtual master_if vif;

  function new(string name = "aw_master_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("AW_M_DRV", "cfg missing")
    vif = cfg.master_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    aw_tx req;
    vif.drv_cb.awvalid <= 1'b0;
    forever begin
      seq_item_port.get_next_item(req);
      @(vif.drv_cb);
      vif.drv_cb.awid    <= req.awid;
      vif.drv_cb.awaddr  <= req.awaddr;
      vif.drv_cb.awlen   <= req.awlen;
      vif.drv_cb.awsize  <= req.awsize;
      vif.drv_cb.awburst <= req.awburst;
      vif.drv_cb.awvalid <= 1'b1;
      do @(vif.drv_cb); while (!vif.drv_cb.awready);
      vif.drv_cb.awvalid <= 1'b0;
      seq_item_port.item_done();
    end
  endtask
endclass
