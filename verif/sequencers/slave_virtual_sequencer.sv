class slave_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(slave_virtual_sequencer)

  b_sequencer b_sqr;
  r_sequencer r_sqr;

  uvm_tlm_analysis_fifo #(aw_tx) aw_fifo;
  uvm_tlm_analysis_fifo #(w_tx)  w_fifo;
  uvm_tlm_analysis_fifo #(ar_tx) ar_fifo;
  mem_model                      mem;

  function new(string name = "slave_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass
