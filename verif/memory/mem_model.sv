class mem_model extends uvm_object;
  `uvm_object_utils(mem_model)

  protected bit [7:0] mem[longint unsigned];

  function new(string name = "mem_model");
    super.new(name);
  endfunction

  function void write_word(bit [ADDR_WIDTH - 1:0] addr,
                           bit [DATA_WIDTH - 1:0] data,
                           bit [STRB_WIDTH - 1:0] strb);
    for (int i = 0; i < STRB_WIDTH; i++) begin
      if (strb[i]) mem[addr + i] = data[i*8 +: 8];
    end
  endfunction

  function bit [DATA_WIDTH - 1:0] read_word(bit [ADDR_WIDTH - 1:0] addr);
    bit [DATA_WIDTH - 1:0] data;
    data = 'x;
    for (int i = 0; i < STRB_WIDTH; i++) begin
      if (mem.exists(addr + i)) data[i*8 +: 8] = mem[addr + i];
    end
    return data;
  endfunction
endclass
