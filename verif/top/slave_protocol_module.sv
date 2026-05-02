`timescale 1ns/1ps

module slave_protocol_module(
  input  logic clk,
  input  logic rst_n
);

  slave_if #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .ID_WIDTH(WID)
  ) slave_if_h (
    .clk(clk),
    .rst_n(rst_n)
  );

  initial begin
    uvm_config_db#(virtual slave_if)::set(null, "uvm_test_top", "slave_vif", slave_if_h);
  end

endmodule
