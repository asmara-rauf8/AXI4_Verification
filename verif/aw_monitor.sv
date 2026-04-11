class aw_monitor extends uvm_monitor;
  `uvm_component_utils(aw_monitor)

  virtual axi_if vif;
  aw_tx tx;
  uvm_analysis_port #(aw_tx) analysis_port;

  function new(string name = "aw_monitor", uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("AW_MON", "Unable to get interface from config_db")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);   
    forever begin
      @(posedge vif.clk);
      
      if (vif.awvalid && vif.awready) begin
        tx = aw_tx::type_id::create("tx");
        
        tx.awvalid = vif.awvalid;
        tx.awid    = vif.awid;
        tx.awaddr  = vif.awaddr;
        tx.awlen   = vif.awlen;
        tx.awsize  = vif.awsize;
        tx.awburst = vif.awburst;
        
        analysis_port.write(tx);
      end
    end
  endtask
endclass
