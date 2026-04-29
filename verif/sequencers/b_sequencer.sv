class b_sequencer extends uvm_sequencer #(b_tx);
  `uvm_component_utils(b_sequencer)

  function new(string name = "b_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass
