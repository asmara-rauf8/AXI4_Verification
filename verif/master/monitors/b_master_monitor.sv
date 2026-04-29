class b_master_monitor extends uvm_monitor;
  `uvm_component_utils(b_master_monitor)

  env_cfg cfg;
  virtual master_if vif;
  uvm_analysis_port #(b_tx) analysis_port;

  function new(string name = "b_master_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("B_M_MON", "cfg missing")
    vif = cfg.master_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    b_tx tx;
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.bvalid && vif.mon_cb.bready) begin
        tx = b_tx::type_id::create("tx");
        tx.bvalid = vif.mon_cb.bvalid;
        tx.bready = vif.mon_cb.bready;
        tx.bid    = vif.mon_cb.bid;
        tx.bresp  = vif.mon_cb.bresp;
        analysis_port.write(tx);
      end
    end
  endtask
endclass
