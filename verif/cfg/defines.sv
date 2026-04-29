parameter int ADDR_WIDTH = 32;
parameter int DATA_WIDTH = 32;
parameter int WID        = 6;
parameter int RID        = 6;
parameter int STRB_WIDTH = DATA_WIDTH/8;

typedef enum bit [1:0] {
  BURST_FIXED = 2'b00,
  BURST_INCR  = 2'b01,
  BURST_WRAP  = 2'b10
} burst_e;

typedef enum bit [1:0] {
  RESP_OKAY   = 2'b00,
  RESP_EXOKAY = 2'b01,
  RESP_SLVERR = 2'b10,
  RESP_DECERR = 2'b11
} resp_e;

typedef enum bit {
  PASSIVE = 1'b0,
  ACTIVE  = 1'b1
} agent_mode_e;

typedef enum int unsigned {
  TB_MODE_B2B      = 0,
  TB_MODE_LOOPBACK = 1
} tb_mode_e;

function automatic int unsigned bytes_per_beat(bit [2:0] size);
  return 1 << size;
endfunction

function automatic int unsigned num_beats(bit [7:0] len);
  return int'(len) + 1;
endfunction

function automatic bit [ADDR_WIDTH-1:0] wrap_boundary(
  bit [ADDR_WIDTH-1:0] base_addr,
  bit [7:0]            len,
  bit [2:0]            size
);
  int unsigned total_bytes;
  total_bytes = num_beats(len) * bytes_per_beat(size);
  return (base_addr / total_bytes) * total_bytes;
endfunction

function automatic bit [ADDR_WIDTH-1:0] beat_addr(
  bit [ADDR_WIDTH-1:0] base_addr,
  bit [7:0]            len,
  bit [2:0]            size,
  bit [1:0]            burst,
  int unsigned         beat_idx
);
  bit [ADDR_WIDTH-1:0] addr;
  bit [ADDR_WIDTH-1:0] boundary;
  int unsigned         total_bytes;

  addr = base_addr;
  case (burst)
    BURST_FIXED: addr = base_addr;
    BURST_INCR:  addr = base_addr + (beat_idx * bytes_per_beat(size));
    BURST_WRAP: begin
      total_bytes = num_beats(len) * bytes_per_beat(size);
      boundary    = wrap_boundary(base_addr, len, size);
      addr        = base_addr + (beat_idx * bytes_per_beat(size));
      if (addr >= boundary + total_bytes) begin
        addr = boundary + (addr - boundary) % total_bytes;
      end
    end
    default: addr = base_addr;
  endcase
  return addr;
endfunction

function automatic bit [STRB_WIDTH-1:0] compute_strb(
  bit [2:0]            size,
  bit [ADDR_WIDTH-1:0] curr_beat_addr
);
  bit [STRB_WIDTH-1:0] mask;
  int unsigned         num_bytes;
  int unsigned         lane;

  mask      = '0;
  num_bytes = bytes_per_beat(size);
  lane      = curr_beat_addr % STRB_WIDTH;

  for (int i = 0; i < num_bytes; i++) begin
    mask[(lane + i) % STRB_WIDTH] = 1'b1;
  end

  return mask;
endfunction
