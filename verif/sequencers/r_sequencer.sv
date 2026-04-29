class r_sequencer extends uvm_sequencer #(r_tx);
  `uvm_component_utils(r_sequencer)

  function new(string name = "r_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass
