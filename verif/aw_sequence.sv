class aw_sequence extends uvm_sequence #(aw_tx);
  `uvm_object_utils(aw_sequence)

  function new(string name = "aw_sequence");
    super.new(name);
  endfunction

  aw_tx  req;
  
  virtual task body();
    req = aw_tx::type_id::create("req");
    
    start_item(req);
    if (!req.randomize()) begin
      `uvm_error("AW_SEQ", "Randomization of aw_tx failed!")
    end
    finish_item(req);
  endtask
endclass
