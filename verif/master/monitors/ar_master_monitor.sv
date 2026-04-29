class ar_master_monitor extends uvm_monitor;
  `uvm_component_utils(ar_master_monitor)

  env_cfg cfg;
  virtual master_if vif;
  uvm_analysis_port #(ar_tx) analysis_port;

  function new(string name = "ar_master_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("AR_M_MON", "cfg missing")
    vif = cfg.master_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    ar_tx tx;
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.arvalid && vif.mon_cb.arready) begin
        tx = ar_tx::type_id::create("tx");
        tx.arvalid = vif.mon_cb.arvalid;
        tx.arready = vif.mon_cb.arready;
        tx.arid    = vif.mon_cb.arid;
        tx.araddr  = vif.mon_cb.araddr;
        tx.arlen   = vif.mon_cb.arlen;
        tx.arsize  = vif.mon_cb.arsize;
        tx.arburst = vif.mon_cb.arburst;
        analysis_port.write(tx);
      end
    end
  endtask
endclass
