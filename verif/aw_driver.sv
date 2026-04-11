class aw_driver extends uvm_driver #(aw_tx);
  `uvm_component_utils(aw_driver)
  
  virtual axi_if vif;
  aw_tx req;

  function new(string name = "aw_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("AW_DRV", "Unable to get interface from config_db")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    vif.awvalid <= 0;
    vif.awid    <= 0;
    vif.awaddr  <= 0;
    vif.awlen   <= 0;
    vif.awsize  <= 0;
    vif.awburst <= 0;

    forever begin
      seq_item_port.get_next_item(req);
      do_item();
      seq_item_port.item_done();
    end
  endtask

  task do_item();
    @(posedge vif.clk);
    vif.awvalid <= 1; 
    vif.awid    <= req.awid;
    vif.awaddr  <= req.awaddr;
    vif.awlen   <= req.awlen;
    vif.awsize  <= req.awsize;
    vif.awburst <= req.awburst;

    do begin
      @(posedge vif.clk);
    end while (!vif.awready);

    vif.awvalid <= 0;
  endtask
endclass
