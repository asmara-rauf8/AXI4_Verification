class b_slave_driver extends uvm_driver #(b_tx);
  `uvm_component_utils(b_slave_driver)

  env_cfg cfg;
  virtual slave_if vif;

  function new(string name = "b_slave_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("B_S_DRV", "cfg missing")
    vif = cfg.slave_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    b_tx req;
    int unsigned delay_cycles;
    vif.drv_cb.bvalid <= 1'b0;
    forever begin
      seq_item_port.get_next_item(req);
      delay_cycles = $urandom_range(cfg.resp_delay_max, cfg.resp_delay_min);
      repeat (delay_cycles) @(vif.drv_cb);
      @(vif.drv_cb);
      vif.drv_cb.bid    <= req.bid;
      vif.drv_cb.bresp  <= req.bresp;
      vif.drv_cb.bvalid <= 1'b1;
      do @(vif.drv_cb); while (!vif.drv_cb.bready);
      vif.drv_cb.bvalid <= 1'b0;
      seq_item_port.item_done();
    end
  endtask
endclass
