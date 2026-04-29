class r_master_monitor extends uvm_monitor;
  `uvm_component_utils(r_master_monitor)

  env_cfg cfg;
  virtual master_if vif;
  uvm_analysis_port #(r_tx) analysis_port;

  function new(string name = "r_master_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("R_M_MON", "cfg missing")
    vif = cfg.master_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    r_tx tx;
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.rvalid && vif.mon_cb.rready) begin
        tx = r_tx::type_id::create("tx");
        tx.rvalid = vif.mon_cb.rvalid;
        tx.rready = vif.mon_cb.rready;
        tx.rid    = vif.mon_cb.rid;
        tx.rdata  = vif.mon_cb.rdata;
        tx.rresp  = vif.mon_cb.rresp;
        tx.rlast  = vif.mon_cb.rlast;
        analysis_port.write(tx);
      end
    end
  endtask
endclass
