class ar_sequencer extends uvm_sequencer #(ar_tx);
  `uvm_component_utils(ar_sequencer)

  function new(string name = "ar_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass
