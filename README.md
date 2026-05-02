# AXI4 Verification

## 1. Project Overview

AXI stands for Advanced eXtensible Interface. It is a high performance, memory mapped protocol from the AMBA family and is widely used to connect processors, memories, DMA engines, accelerators, and peripherals in SoC designs.

This repository contains the verification environment of an AXI4 protocol. This verification environment can:

- generate AXI4 write and read traffic
- drive all five AXI4 channels: `AW`, `W`, `B`, `AR`, and `R`
- support `FIXED`, `INCR`, and `WRAP` burst types
- support configurable burst length, transfer size, ID, and base address
- verify `AW`,`W`, `B`, `AR`, and `R` channel behavior
- compare master side and slave side monitored transactions in the scoreboard
- maintain a memory model and check read data against previously written data

This repository does not include an AXI4 RTL DUT. The `master_if` and `slave_if` interfaces are directly connected in `verif/top/top.sv`. This creates a back to back verification mode in which the master side generates AXI4 traffic and the slave side responds through the same connected bus signals.

### AXI4 Master

The AXI4 master initiates write and read transactions. In this repository, the master side is represented by master protocol module which communicate with master agents through interface. The master virtual sequencer generates write bursts first and then issues matching read bursts.

### AXI4 Slave

The AXI4 slave responds to read address and write data activity from the master. In this repository, the slave side is represented by slave protocol module which communicate with slave agents through interface. The slave virtual sequencer monitors incoming `AW`, `W`, and `AR` activity, updates the memory model for writes, and generates `B` and `R` responses.

### VIP Reuse

This VIP is reusable and can be adapted depending on the integration style:

- the master side VIP can be used when the DUT behaves like an AXI4 slave
- the slave side VIP can be used when the DUT behaves like an AXI4 master
- the full environment can be used in back to back mode for protocol level verification without RTL

### Default Configuration

The key parameters in this repository are:

- `ADDR_WIDTH = 32`
- `DATA_WIDTH = 32`
- `WID = 6`
- `RID = 6`
- `STRB_WIDTH = DATA_WIDTH/8 = 4`

The top level clock and reset behavior are:

- `timescale = 1ns/1ps`
- `clk` toggles every `5ns`
- clock period = `10ns`
- reset is held low for `5` clock cycles before release

The default `sanity_test` setup is:

- `num_wr_txns = 4`
- `num_rd_txns = 4`
- `base_addr = 'h1000`
- `txn_len = 8'd0` which means `1` beat per burst
- `txn_size = 3'd2` which means `4` bytes per beat
- `txn_burst = BURST_INCR`

## 2. Verification Architecture

Below is the architecture diagram for this project:

```text
+-------------------------------------------------------------------------------------+
|                                      tb_top                                         |
|                                                                                     |
|  +-------------------------------------------------------------------------------+  |
|  |                                  UVM Test                                     |  |
|  |                                                                               |  |
|  |  +-------------------------------------------------------------------------+  |  |
|  |  |                             environment                                 |  |  |
|  |  |                                                                         |  |  |
|  |  |  +----------------------+                     +----------------------+  |  |  |
|  |  |  |    master agents     |                     |     slave agents     |  |  |  |
|  |  |  | sequencer/driver/mon |                     |  sequencer/driver/mon|  |  |  |
|  |  |  +-+--------+-----------+                     +----------+---------+-+  |  |  |
|  |  |    |        |                                            |         |    |  |  |
|  |  |    |        v                                            v         |    |  |  |
|  |  |    |    +--------------------------------------------------+       |    |  |  |
|  |  |    |    |                     scoreboard                   |       |    |  |  |
|  |  |    |    +--------------------------------------------------+       |    |  |  |
|  |  +----|---------------------------------------------------------------|----+  |  |
|  |       |                   +------------------------+                  |       |  |
|  |       |                   |       mem_model        |                  |       |  |
|  |       |                   +------------------------+                  |       |  |
|  +-------|---------------------------------------------------------------|-------+  |
|          |   +-----------------------+        +----------------------+   |          | 
|          |   | master_protocol_module|        | slave_protocol_module|   |          | 
|          |   | +------------------+  |        | +------------------+ |   |          |  
|          + > | |    master_if     |  |        | |     slave_if     | | <-+          |  
|              | +------------------+  |        | +------------------+ |              |  
|              +----------+------------+        +----------+-----------+              |  
|                         |                               |                           |  
|                         +-------------------------------+                           |  
|                                                                                     |
+-------------------------------------------------------------------------------------+

```

### Key Components

- `master_protocol_module`: RTL protocol module that instantiates `master_if` and generates clock/reset (external to the UVM environment)
- `slave_protocol_module`: RTL protocol module that instantiates `slave_if` (external to the UVM environment)
- `env` (UVM): contains `master` and `slave` agents (sequencer/driver/monitor), virtual sequencers, and the `scoreboard`
- `master_virtual_sequencer`: starts master write address, write data, and read address sequences
- `slave_virtual_sequencer`: collects master requests and starts `B` and `R` response sequences
- `AW/W/AR/B/R driver`: drives write, read and response data
- `AW/W/AR/B/R monitors`: passively sample channel transactions on both master and slave interfaces
- `scoreboard`: compares master and slave transactions and checks read data against memory contents
- `mem_model`: created in `sanity_test`, stored in `env_cfg`, and used by the scoreboard and slave virtual sequence to store write data and provide expected read data

## 3. AXI4 Channels and Signals

The signal list below summarizes the main AXI4 channels relevant to this repository.

| Channel | Direction | Main Signals | Description |
|---|---|---|---|
| `AW` | Master to Slave | `awid`, `awaddr`, `awlen`, `awsize`, `awburst`, `awvalid`, `awready` | Write address and burst attributes |
| `W` | Master to Slave | `wid`, `wdata`, `wstrb`, `wlast`, `wvalid`, `wready` | Write data beats and byte enables |
| `B` | Slave to Master | `bid`, `bresp`, `bvalid`, `bready` | Write response channel |
| `AR` | Master to Slave | `arid`, `araddr`, `arlen`, `arsize`, `arburst`, `arvalid`, `arready` | Read address and burst attributes |
| `R` | Slave to Master | `rid`, `rdata`, `rresp`, `rlast`, `rvalid`, `rready` | Read response data channel |

## 4. Test Suite

At present, the repository contains a single baseline test:

| Test Name | Description |
|---|---|
| `sanity_test` | Creates `4` write transactions and `4` read transactions, uses base address `'h1000`, uses single beat `INCR` bursts, runs the slave virtual sequence in parallel, updates the memory model on writes, and checks returned `B` and `R` responses through the scoreboard. |

### Current Flow of `sanity_test`

- the slave virtual sequence starts first and waits for incoming `AW`, `W`, and `AR` activity
- the master virtual sequence generates write bursts
- the slave side captures those writes and stores them in the memory model
- the slave side returns `OKAY` write responses on the `B` channel
- the master virtual sequence then generates matching read bursts
- the slave side returns read data from the memory model on the `R` channel
- the scoreboard compares master and slave observations and validates read data

### Future Work

- connect the VIP to an actual AXI4 DUT
- add more directed tests for `FIXED`, `INCR`, and `WRAP` burst scenarios
- add multi beat stress cases and randomized outstanding transactions
- expand functional coverage beyond `AW` and `AR`
- add error response and corner case protocol checking

## 5. How to Run

- Open ModelSim/QuestaSim
- `cd sim`
- `do run.do`

The default test in `run.do` is `sanity_test`.

To run a different UVM test, change the `+UVM_TESTNAME=` argument in [sim/run.do]

The repository also supports a `TB_MODE` plusarg in `sanity_test`:

- `TB_MODE=B2B` is the default mode
- `TB_MODE=LOOPBACK` is recognized by the test configuration, although the current top level still uses direct interface connection without a DUT
