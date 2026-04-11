//////////////////////////////
//
// Filename : aw_seq.sv
// Author : Asmara Rauf
//
// Address write sequence
//
//////////////////////////////


class aw_seq extends uvm_sequence #(aw_tx);

  // factory registration
  `uvm_object_utils(aw_seq)

  // constructor
  function new(string name="aw_seq");
    super.new(name);
  endfunction

  // declarations
  aw_tx  req;
  
  // main task of the sequence
  virtual task body();
    req = aw_tx::type_id::create("req");
    start_item(txn);
    req.randomize();
    finish_item(txn); 
  endtask

endclass
