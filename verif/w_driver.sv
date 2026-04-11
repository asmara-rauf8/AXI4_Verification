class w_driver extends uvm_driver #(w_tx);
  `uvm_component_utils(w_driver)
  
  virtual axi_if vif;
  w_tx req;

  function new(string name = "w_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("W_DRV", "Unable to get interface from config_db")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    // Initialize default interface values
    vif.wvalid <= 0;
    vif.wid    <= 0;
    vif.wdata  <= 0;
    vif.wstrb  <= 0;
    vif.wlast  <= 0;

    forever begin
      seq_item_port.get_next_item(req);
      do_drive();
      seq_item_port.item_done();
    end
  endtask

  virtual task do_drive();
    @(posedge vif.clk);
    
    vif.wvalid <= 1; 
    vif.wid    <= req.wid;
    vif.wdata  <= req.wdata;
    vif.wstrb  <= req.wstrb;
    vif.wlast  <= req.wlast;

    do begin
      @(posedge vif.clk);
    end while (!vif.wready);

    vif.wvalid <= 0;
    vif.wlast  <= 0; 
  endtask
endclass
