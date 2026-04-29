interface master_if #(
  int ADDR_WIDTH = 32,
  int DATA_WIDTH = 32,
  int ID_WIDTH   = 6
) (
  input logic clk,
  input logic rst_n
);
  localparam int STRB_WIDTH = DATA_WIDTH/8;

  logic [ID_WIDTH-1:0] awid;
  logic [ADDR_WIDTH-1:0] awaddr;
  logic [7:0] awlen;
  logic [2:0] awsize;
  logic [1:0] awburst;
  logic awvalid;
  logic awready;

  logic [ID_WIDTH-1:0] wid;
  logic [DATA_WIDTH-1:0] wdata;
  logic [STRB_WIDTH-1:0] wstrb;
  logic wlast;
  logic wvalid;
  logic wready;

  logic [ID_WIDTH-1:0] bid;
  logic [1:0] bresp;
  logic bvalid;
  logic bready;

  logic [ID_WIDTH-1:0] arid;
  logic [ADDR_WIDTH-1:0] araddr;
  logic [7:0] arlen;
  logic [2:0] arsize;
  logic [1:0] arburst;
  logic arvalid;
  logic arready;

  logic [ID_WIDTH-1:0] rid;
  logic [DATA_WIDTH-1:0] rdata;
  logic [1:0] rresp;
  logic rlast;
  logic rvalid;
  logic rready;

  clocking drv_cb @(posedge clk);
    default input #1step output #1step;
    output awid, awaddr, awlen, awsize, awburst, awvalid;
    input  awready;
    output wid, wdata, wstrb, wlast, wvalid;
    input  wready;
    input  bid, bresp, bvalid;
    output bready;
    output arid, araddr, arlen, arsize, arburst, arvalid;
    input  arready;
    input  rid, rdata, rresp, rlast, rvalid;
    output rready;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1step output #1step;
    input awid, awaddr, awlen, awsize, awburst, awvalid, awready;
    input wid, wdata, wstrb, wlast, wvalid, wready;
    input bid, bresp, bvalid, bready;
    input arid, araddr, arlen, arsize, arburst, arvalid, arready;
    input rid, rdata, rresp, rlast, rvalid, rready;
  endclocking
endinterface
