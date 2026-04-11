package pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "../aw_tx.sv"
  `include "../w_tx.sv"
  `include "../b_tx.sv"
  `include "../ar_tx.sv"
  `include "../r_tx.sv"
  `include "../aw_sequence.sv"
  `include "../w_sequence.sv"
  `include "../aw_driver.sv"
  `include "../w_driver.sv"
  `include "../aw_monitor.sv"  
  `include "../w_monitor.sv"
  `include "../scb/env_scb.sv"
  `include "../env/environment.sv"
  `include "../test/sanity_test.sv"
endpackage : pkg
