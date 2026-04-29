class master_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(master_virtual_sequencer)

  aw_sequencer aw_sqr;
  w_sequencer  w_sqr;
  ar_sequencer ar_sqr;

  function new(string name = "master_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass
