`ifndef I3C_MULTI_LEN_WRITE_VIRTUAL_SEQ_INCLUDED_
`define I3C_MULTI_LEN_WRITE_VIRTUAL_SEQ_INCLUDED_

class i3c_multi_len_write_virtual_seq extends top_virtual_base_seq;
  `uvm_object_utils(i3c_multi_len_write_virtual_seq)

  uvm_status_e   status;
  uvm_reg_data_t ctrl_val;
  uvm_reg_data_t ctrl_mirror;

  // Transfer lengths to test — each covers different len bits
  // len=2  → bit1, len=4  → bit2, len=8  → bit3
  // len=32 → bit5, len=64 → bit6
  bit [7:0] lengths[$] = '{8'd2, 8'd4, 8'd8, 8'd32, 8'd64};

  function new(string name = "i3c_multi_len_write_virtual_seq");
    super.new(name);
  endfunction

  task body();
    i3c_target_writeOperationWith8bitsData_seq target_seq_write;

    // Null checks
    if(i3c_env_cfg_h == null)
      `uvm_fatal("CFG_NULL",
        "i3c_env_cfg_h is NULL inside virtual sequence")
    if(i3c_env_cfg_h.regBlockHandle == null)
      `uvm_fatal("RAL_NULL",
        "regBlockHandle is NULL inside virtual sequence")

    super.body();

    `uvm_info(get_type_name(),
      "Starting multi-length write sequence for coverage", UVM_LOW)

    // Run one transfer per length value
    foreach(lengths[i]) begin

      `uvm_info(get_type_name(), $sformatf(
        "=== Transfer %0d: length=%0d bytes ===",
        i, lengths[i]), UVM_LOW)

      // Step 1: Start target sequence in background
      // Target must be ready before master sends
      fork
        begin
          target_seq_write =
            i3c_target_writeOperationWith8bitsData_seq::type_id::create(
              $sformatf("target_seq_write_%0d", i));
          target_seq_write.start(
            p_sequencer.i3c_target_seqr_h);
        end
      join_none

      // Step 2: Write lengths[i] bytes to WDATAB
      // Each byte is random (1-254 to avoid all-zeros/all-ones)
      repeat(lengths[i]) begin
        i3c_env_cfg_h.regBlockHandle.wdatab_inst.write(
          status,
          $urandom_range(1, 254),
          .parent(this)
        );
      end

      `uvm_info(get_type_name(), $sformatf(
        "Wrote %0d bytes to WDATAB", lengths[i]), UVM_LOW)

      // Step 3: Configure CTRL for this length
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.address.set(
        i3c_env_cfg_h.i3c_target_agent_cfg_h[0].targetAddress);
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.length.set(
        lengths[i]);        // ← key — different length each iteration
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.direction.set(
        1'b0);              // WRITE
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.cmd_type.set(
        2'b00);
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.start.set(
        1'b1);

      ctrl_val = i3c_env_cfg_h.regBlockHandle.ctrl_inst.get();
      `uvm_info(get_type_name(), $sformatf(
        "CTRL value before update = 0x%0h (len=%0d)",
        ctrl_val, lengths[i]), UVM_LOW)

      // Step 4: Trigger the transfer
      i3c_env_cfg_h.regBlockHandle.ctrl_inst.update(
        status, .parent(this));

      ctrl_mirror =
        i3c_env_cfg_h.regBlockHandle.ctrl_inst.get_mirrored_value();
      `uvm_info(get_type_name(), $sformatf(
        "CTRL mirrored after update = 0x%0h", ctrl_mirror), UVM_LOW)

      i3c_env_cfg_h.regBlockHandle.ctrl_inst.mirror(
        status, UVM_NO_CHECK);

      // Step 5: Wait for transfer to complete
      // Longer transfers need more time
      // Base: 2000ns per byte + overhead
      #(lengths[i] * 2000 + 10000);

      `uvm_info(get_type_name(), $sformatf(
        "Transfer %0d complete (len=%0d)", i, lengths[i]), UVM_LOW)

    end // foreach

    `uvm_info(get_type_name(),
      "Multi-length write sequence complete", UVM_LOW)

  endtask

endclass
`endif
