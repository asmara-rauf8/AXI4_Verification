class r_slave_driver extends uvm_driver #(r_tx);
  `uvm_component_utils(r_slave_driver)

  env_cfg cfg;
  virtual slave_if vif;

  function new(string name = "r_slave_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("R_S_DRV", "cfg missing")
    vif = cfg.slave_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    r_tx req;
    int unsigned delay_cycles;
    vif.drv_cb.rvalid <= 1'b0;
    forever begin
      seq_item_port.get_next_item(req);
      delay_cycles = $urandom_range(cfg.resp_delay_max, cfg.resp_delay_min);
      repeat (delay_cycles) @(vif.drv_cb);
      @(vif.drv_cb);
      vif.drv_cb.rid    <= req.rid;
      vif.drv_cb.rdata  <= req.rdata;
      vif.drv_cb.rresp  <= req.rresp;
      vif.drv_cb.rlast  <= req.rlast;
      vif.drv_cb.rvalid <= 1'b1;
      do @(vif.drv_cb); while (!vif.drv_cb.rready);
      vif.drv_cb.rvalid <= 1'b0;
      vif.drv_cb.rlast  <= 1'b0;
      seq_item_port.item_done();
    end
  endtask
endclass
