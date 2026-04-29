class env_cfg extends uvm_object;
  `uvm_object_utils(env_cfg)

  int unsigned addr_width     = ADDR_WIDTH;
  int unsigned data_width     = DATA_WIDTH;
  int unsigned id_width       = WID;
  int unsigned strb_width     = STRB_WIDTH;
  tb_mode_e    tb_mode        = TB_MODE_B2B;
  bit en_burst_fixed          = 1'b1;
  bit en_burst_wrap           = 1'b1;
  bit en_out_of_order         = 1'b0;
  int unsigned resp_delay_min = 0;
  int unsigned resp_delay_max = 2;

  virtual master_if master_vif;
  virtual slave_if  slave_vif;
  mem_model mem;

  function new(string name = "env_cfg");
    super.new(name);
  endfunction
endclass
