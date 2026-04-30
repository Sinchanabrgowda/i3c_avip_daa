`ifndef I3C_FIFO_FULL_READ_VIRTUAL_SEQ_INCLUDED_
`define I3C_FIFO_FULL_READ_VIRTUAL_SEQ_INCLUDED_

class i3c_fifo_full_read_virtual_seq extends top_virtual_base_seq;
  `uvm_object_utils(i3c_fifo_full_read_virtual_seq)

  uvm_status_e    status;
  uvm_reg_data_t  ctrl_val;
  uvm_reg_data_t  rdatab_val;
  localparam int  FIFO_DEPTH = 16;

  byte expected_data[16];

  function new(string name = "i3c_fifo_full_read_virtual_seq");
    super.new(name);
  endfunction

task body();
  super.body();
  `uvm_info(get_type_name(), "Starting FIFO FULL READ test", UVM_LOW)
  
//  byte expected_data[16];
  
  // Pre-calculate expected data (same pattern target will use)
  for (int i = 0; i < 16; i++) begin
    expected_data[i] = i;  // 0x00 through 0x0F
  end

  //====================================================
  // START TARGET (will drive 0x00-0x0F on I3C bus)
  //====================================================
  fork
    begin
      i3c_target_readOperationWith8bitsData_seq target_seq;
      target_seq = i3c_target_readOperationWith8bitsData_seq::type_id
                   ::create("target_seq");
      target_seq.start(p_sequencer.i3c_target_seqr_h);
    end
  join_none

  //====================================================
  // TRIGGER READ (controller receives from target → fills RX FIFO)
  //====================================================
  i3c_env_cfg_h.regBlockHandle.ctrl_inst.address.set(TARGET0_ADDRESS);
  i3c_env_cfg_h.regBlockHandle.ctrl_inst.length.set(8'd16);
  i3c_env_cfg_h.regBlockHandle.ctrl_inst.direction.set(1'b1); // READ
  i3c_env_cfg_h.regBlockHandle.ctrl_inst.update(status, .parent(this));
  
  #50000;  // Wait for I3C transfer

  //====================================================
  // READ 16 BYTES (should match what target sent)
  //====================================================
  for (int i = 0; i < FIFO_DEPTH; i++) begin
    i3c_env_cfg_h.regBlockHandle.rdatab_inst.read(
      status, rdatab_val, .parent(this));
    
    if (rdatab_val == expected_data[i]) begin
      `uvm_info("FIFO_CHECK",
        $sformatf("RDATAB[%0d] = 0x%0h ✓", i, rdatab_val), UVM_LOW)
    end else begin
      `uvm_error("FIFO_CHECK",
        $sformatf("RDATAB[%0d] mismatch: exp=0x%0h got=0x%0h", 
                  i, expected_data[i], rdatab_val))
    end
  end

  //====================================================
  // 17th READ (FIFO empty → should return 0 or stale)
  //====================================================
  i3c_env_cfg_h.regBlockHandle.rdatab_inst.read(
    status, rdatab_val, .parent(this));
  `uvm_info("FIFO_UNDERFLOW",
    $sformatf("17th read (FIFO empty) = 0x%0h", rdatab_val), UVM_LOW)

  `uvm_info(get_type_name(), "FIFO FULL READ test completed", UVM_LOW)
endtask

endclass : i3c_fifo_full_read_virtual_seq
`endif
