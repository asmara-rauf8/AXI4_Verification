class w_sequence extends uvm_sequence #(w_tx);
  `uvm_object_utils(w_sequence)

  function new(string name = "w_sequence");
    super.new(name);
  endfunction

  virtual task body();
    req = w_tx::type_id::create("req");
    
    start_item(req);
    if (!req.randomize()) begin
      `uvm_error("W_SEQ", "Randomization of w_tx failed!")
    end
    finish_item(req);
  endtask
endclass
