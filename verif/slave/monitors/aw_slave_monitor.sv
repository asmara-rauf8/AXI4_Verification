class aw_slave_monitor extends uvm_monitor;
  `uvm_component_utils(aw_slave_monitor)

  env_cfg cfg;
  virtual slave_if vif;
  uvm_analysis_port #(aw_tx) analysis_port;

  function new(string name = "aw_slave_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(env_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("AW_S_MON", "cfg missing")
    vif = cfg.slave_vif;
  endfunction

  virtual task run_phase(uvm_phase phase);
    aw_tx tx;
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.awvalid && vif.mon_cb.awready) begin
        tx = aw_tx::type_id::create("tx");
        tx.awvalid = vif.mon_cb.awvalid;
        tx.awready = vif.mon_cb.awready;
        tx.awid    = vif.mon_cb.awid;
        tx.awaddr  = vif.mon_cb.awaddr;
        tx.awlen   = vif.mon_cb.awlen;
        tx.awsize  = vif.mon_cb.awsize;
        tx.awburst = vif.mon_cb.awburst;
        analysis_port.write(tx);
      end
    end
  endtask
endclass
