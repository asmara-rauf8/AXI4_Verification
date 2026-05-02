`timescale 1ns/1ps

module top;
  import uvm_pkg::*;
  import pkg::*;

  logic clk_from_master;
  logic rst_n_from_master;

  master_protocol_module master_pm (
    .clk(clk_from_master),
    .rst_n(rst_n_from_master)
  );

  slave_protocol_module slave_pm (
    .clk(clk_from_master),
    .rst_n(rst_n_from_master)
  );

  assign slave_pm.slave_if_h.awid     = master_pm.master_if_h.awid;
  assign slave_pm.slave_if_h.awaddr   = master_pm.master_if_h.awaddr;
  assign slave_pm.slave_if_h.awlen    = master_pm.master_if_h.awlen;
  assign slave_pm.slave_if_h.awsize   = master_pm.master_if_h.awsize;
  assign slave_pm.slave_if_h.awburst  = master_pm.master_if_h.awburst;
  assign slave_pm.slave_if_h.awvalid  = master_pm.master_if_h.awvalid;
  assign master_pm.master_if_h.awready = slave_pm.slave_if_h.awready;

  assign slave_pm.slave_if_h.wid     = master_pm.master_if_h.wid;
  assign slave_pm.slave_if_h.wdata   = master_pm.master_if_h.wdata;
  assign slave_pm.slave_if_h.wstrb   = master_pm.master_if_h.wstrb;
  assign slave_pm.slave_if_h.wlast   = master_pm.master_if_h.wlast;
  assign slave_pm.slave_if_h.wvalid  = master_pm.master_if_h.wvalid;
  assign master_pm.master_if_h.wready = slave_pm.slave_if_h.wready;

  assign slave_pm.slave_if_h.arid     = master_pm.master_if_h.arid;
  assign slave_pm.slave_if_h.araddr   = master_pm.master_if_h.araddr;
  assign slave_pm.slave_if_h.arlen    = master_pm.master_if_h.arlen;
  assign slave_pm.slave_if_h.arsize   = master_pm.master_if_h.arsize;
  assign slave_pm.slave_if_h.arburst  = master_pm.master_if_h.arburst;
  assign slave_pm.slave_if_h.arvalid  = master_pm.master_if_h.arvalid;
  assign master_pm.master_if_h.arready = slave_pm.slave_if_h.arready;

  assign master_pm.master_if_h.bid    = slave_pm.slave_if_h.bid;
  assign master_pm.master_if_h.bresp  = slave_pm.slave_if_h.bresp;
  assign master_pm.master_if_h.bvalid = slave_pm.slave_if_h.bvalid;
  assign slave_pm.slave_if_h.bready  = master_pm.master_if_h.bready;

  assign master_pm.master_if_h.rid    = slave_pm.slave_if_h.rid;
  assign master_pm.master_if_h.rdata  = slave_pm.slave_if_h.rdata;
  assign master_pm.master_if_h.rresp  = slave_pm.slave_if_h.rresp;
  assign master_pm.master_if_h.rlast  = slave_pm.slave_if_h.rlast;
  assign master_pm.master_if_h.rvalid = slave_pm.slave_if_h.rvalid;
  assign slave_pm.slave_if_h.rready  = master_pm.master_if_h.rready;

  initial begin
    run_test("sanity_test");
  end
endmodule
