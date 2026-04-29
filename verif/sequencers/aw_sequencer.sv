class aw_sequencer extends uvm_sequencer #(aw_tx);
  `uvm_component_utils(aw_sequencer)

  function new(string name = "aw_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass
