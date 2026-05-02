`timescale 1ns/1ps

module master_protocol_module(
  output logic clk,
  output logic rst_n
);

  master_if #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .ID_WIDTH(WID)
  ) master_if_h (
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

  initial begin
    uvm_config_db#(virtual master_if)::set(null, "uvm_test_top", "master_vif", master_if_h);
  end

endmodule
