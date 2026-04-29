class w_master_monitor extends uvm_monitor;
  `uvm_component_utils(w_master_monitor)

  env_cfg cfg;
  virtual master_if vif;
  uvm_analysis_port #(w_tx) analysis_port;

  function new(string name = "w_master_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("W_M_MON", "cfg missing")
    vif = cfg.master_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    w_tx tx;
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.wvalid && vif.mon_cb.wready) begin
        tx = w_tx::type_id::create("tx");
        tx.wvalid = vif.mon_cb.wvalid;
        tx.wready = vif.mon_cb.wready;
        tx.wid    = vif.mon_cb.wid;
        tx.wdata  = vif.mon_cb.wdata;
        tx.wstrb  = vif.mon_cb.wstrb;
        tx.wlast  = vif.mon_cb.wlast;
        analysis_port.write(tx);
      end
    end
  endtask
endclass
