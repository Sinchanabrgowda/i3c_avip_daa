`ifndef I3C_RX_FIFO_FULL_VIRTUAL_SEQ_INCLUDED_
`define I3C_RX_FIFO_FULL_VIRTUAL_SEQ_INCLUDED_

class i3c_rx_fifo_full_virtual_seq extends top_virtual_base_seq;
  `uvm_object_utils(i3c_rx_fifo_full_virtual_seq)

  uvm_status_e   status;
  uvm_reg_data_t ctrl_val;
  uvm_reg_data_t ctrl_mirror;

  // Number of reads to do without draining RX FIFO
  // RX FIFO depth = 16 → do 16 reads to fill it
  int unsigned num_reads = 16;

  function new(string name = "i3c_rx_fifo_full_virtual_seq");
    super.new(name);
  endfunction

  task body();
    i3c_target_readOperationWith8bitsData_seq tgt_read_seq;

    // Null checks
    if(i3c_env_cfg_h == null)
      `uvm_fatal("CFG_NULL",
        "i3c_env_cfg_h is NULL inside virtual sequence")
    if(i3c_env_cfg_h.regBlockHandle == null)
      `uvm_fatal("RAL_NULL",
        "regBlockHandle is NULL inside virtual sequence")

    super.body();

    `uvm_info(get_type_name(), $sformatf(
      "Starting RX FIFO full sequence — doing %0d reads",
      num_reads), UVM_LOW)

    // Do num_reads READ transactions without draining RX FIFO
    // This should fill rx_full and toggle rx_ready, rx_wdata
    repeat(num_reads) begin

      // Start target read sequence in background
      fork
        begin
          tgt_read_seq =
            i3c_target_readOperationWith8bitsData_seq::type_id::create(
              "tgt_read_seq");
          tgt_read_seq.start(p_sequencer.i3c_target_seqr_h);
        end
      join_none

      // Configure CTRL for READ
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.address.set(
        i3c_env_cfg_h.i3c_target_agent_cfg_h[0].targetAddress);
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.length.set(8'd1);
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.direction.set(
        1'b1);     // READ
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.cmd_type.set(
        2'b00);
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.start.set(1'b1);

      ctrl_val = i3c_env_cfg_h.regBlockHandle.ctrl_inst.get();
      `uvm_info(get_type_name(), $sformatf(
        "CTRL before READ trigger = 0x%0h", ctrl_val), UVM_LOW)

      // Trigger READ
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.update(
        status, .parent(this));

      ctrl_mirror =
        i3c_env_cfg_h.regBlockHandle.ctrl_inst.get_mirrored_value();
      `uvm_info(get_type_name(), $sformatf(
        "CTRL mirrored after update = 0x%0h", ctrl_mirror), UVM_LOW)

      i3c_env_cfg_h.regBlockHandle.ctrl_inst.mirror(
        status, UVM_NO_CHECK);

      // Wait for READ to complete on bus
      #2000;

      // Intentionally NOT reading RDATAB here
      // → data stays in RX FIFO → fills up!
      `uvm_info(get_type_name(),
        "READ triggered — NOT draining RDATAB", UVM_LOW)

    end // repeat

    `uvm_info(get_type_name(),
      "RX FIFO should now be full — rx_full=1 rx_ready=1",
      UVM_LOW)

    // Now drain RX FIFO to verify data
    `uvm_info(get_type_name(),
      "Draining RX FIFO via RDATAB reads", UVM_LOW)

    repeat(num_reads) begin
      uvm_reg_data_t rdata;
      i3c_env_cfg_h.regBlockHandle.rdatab_inst.read(
        status, rdata, .parent(this));
      `uvm_info(get_type_name(), $sformatf(
        "RDATAB drained = 0x%0x", rdata), UVM_LOW)
    end

    `uvm_info(get_type_name(),
      "RX FIFO full sequence complete", UVM_LOW)

  endtask

endclass
`endif
