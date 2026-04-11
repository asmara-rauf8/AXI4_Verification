class w_monitor extends uvm_monitor;
  `uvm_component_utils(w_monitor)

  virtual axi_if vif;
  w_tx tx;
  uvm_analysis_port #(w_tx) analysis_port;

  function new(string name = "w_monitor", uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("W_MON", "Unable to get interface from config_db")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    
    forever begin
      @(posedge vif.clk);
      
      if (vif.wvalid && vif.wready) begin
        tx = w_tx::type_id::create("tx");
        
        tx.wvalid = vif.wvalid;
        tx.wid    = vif.wid;
        tx.wdata  = vif.wdata;
        tx.wstrb  = vif.wstrb;
        tx.wlast  = vif.wlast;
        
        analysis_port.write(tx);
      end
    end
  endtask
endclass
