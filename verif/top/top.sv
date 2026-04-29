`timescale 1ns/1ps

module top;
  import uvm_pkg::*;
  import pkg::*;

  logic clk;
  logic rst_n;

  master_if #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .ID_WIDTH(WID)
  ) master_if_h (
    .clk(clk),
    .rst_n(rst_n)
  );

  slave_if #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .ID_WIDTH(WID)
  ) slave_if_h (
    .clk(clk),
    .rst_n(rst_n)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst_n = 1'b0;
    repeat (5) @(posedge clk);
    rst_n = 1'b1;
  end

  assign slave_if_h.awid     = master_if_h.awid;
  assign slave_if_h.awaddr   = master_if_h.awaddr;
  assign slave_if_h.awlen    = master_if_h.awlen;
  assign slave_if_h.awsize   = master_if_h.awsize;
  assign slave_if_h.awburst  = master_if_h.awburst;
  assign slave_if_h.awvalid  = master_if_h.awvalid;
  assign master_if_h.awready = slave_if_h.awready;

  assign slave_if_h.wid     = master_if_h.wid;
  assign slave_if_h.wdata   = master_if_h.wdata;
  assign slave_if_h.wstrb   = master_if_h.wstrb;
  assign slave_if_h.wlast   = master_if_h.wlast;
  assign slave_if_h.wvalid  = master_if_h.wvalid;
  assign master_if_h.wready = slave_if_h.wready;

  assign slave_if_h.arid     = master_if_h.arid;
  assign slave_if_h.araddr   = master_if_h.araddr;
  assign slave_if_h.arlen    = master_if_h.arlen;
  assign slave_if_h.arsize   = master_if_h.arsize;
  assign slave_if_h.arburst  = master_if_h.arburst;
  assign slave_if_h.arvalid  = master_if_h.arvalid;
  assign master_if_h.arready = slave_if_h.arready;

  assign master_if_h.bid    = slave_if_h.bid;
  assign master_if_h.bresp  = slave_if_h.bresp;
  assign master_if_h.bvalid = slave_if_h.bvalid;
  assign slave_if_h.bready  = master_if_h.bready;

  assign master_if_h.rid    = slave_if_h.rid;
  assign master_if_h.rdata  = slave_if_h.rdata;
  assign master_if_h.rresp  = slave_if_h.rresp;
  assign master_if_h.rlast  = slave_if_h.rlast;
  assign master_if_h.rvalid = slave_if_h.rvalid;
  assign slave_if_h.rready  = master_if_h.rready;

  initial begin
    uvm_config_db#(virtual master_if)::set(null, "uvm_test_top", "master_vif", master_if_h);
    uvm_config_db#(virtual slave_if)::set(null, "uvm_test_top", "slave_vif", slave_if_h);
    run_test("sanity_test");
  end
endmodule
