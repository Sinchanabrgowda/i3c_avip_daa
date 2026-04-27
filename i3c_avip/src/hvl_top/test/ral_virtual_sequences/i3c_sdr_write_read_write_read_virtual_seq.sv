`ifndef I3C_SDR_WRITE_READ_WRITE_READ_VIRTUAL_SEQ_INCLUDED_
`define I3C_SDR_WRITE_READ_WRITE_READ_VIRTUAL_SEQ_INCLUDED_

class i3c_sdr_write_read_write_read_virtual_seq extends top_virtual_base_seq;

  `uvm_object_utils(i3c_sdr_write_read_write_read_virtual_seq)

  uvm_status_e status;
  uvm_reg_data_t rdata;
  uvm_reg_data_t wdatab_mirror;

  function new(string name = "i3c_sdr_write_read_write_read_virtual_seq");
    super.new(name);
  endfunction


  task body();

    i3c_target_writeOperationWith8bitsData_seq target_write_seq;
    i3c_target_readOperationWith8bitsData_seq  target_read_seq;

    super.body();


    fork
      forever begin
        target_write_seq =
          i3c_target_writeOperationWith8bitsData_seq::type_id::create("target_write_seq");
        target_write_seq.start(p_sequencer.i3c_target_seqr_h);
      end

      forever begin
        target_read_seq =
          i3c_target_readOperationWith8bitsData_seq::type_id::create("target_read_seq");
        target_read_seq.start(p_sequencer.i3c_target_seqr_h);
      end
    join_none;


    i3c_env_cfg_h.regBlockHandle.wdatab_inst.write(status, 8'hA5);

    wdatab_mirror =
      i3c_env_cfg_h.regBlockHandle.wdatab_inst.get_mirrored_value();

    i3c_env_cfg_h.regBlockHandle.wdatab_inst.mirror(status, UVM_NO_CHECK);


    i3c_env_cfg_h.regBlockHandle.ctrl_inst.address.set(TARGET0_ADDRESS);
    i3c_env_cfg_h.regBlockHandle.ctrl_inst.length.set(8'd1);
    i3c_env_cfg_h.regBlockHandle.ctrl_inst.direction.set(1'b0);
    i3c_env_cfg_h.regBlockHandle.ctrl_inst.cmd_type.set(2'b00);
    i3c_env_cfg_h.regBlockHandle.ctrl_inst.start.set(1'b1);

    i3c_env_cfg_h.regBlockHandle.ctrl_inst.update(status);

    #5000;


    i3c_env_cfg_h.regBlockHandle.ctrl_inst.direction.set(1'b1);

    i3c_env_cfg_h.regBlockHandle.ctrl_inst.start.set(1'b1);

    i3c_env_cfg_h.regBlockHandle.ctrl_inst.update(status);

    #5000;

    i3c_env_cfg_h.regBlockHandle.rdatab_inst.read(status, rdata);


    i3c_env_cfg_h.regBlockHandle.wdatab_inst.write(status, 8'h3C);

    wdatab_mirror =
      i3c_env_cfg_h.regBlockHandle.wdatab_inst.get_mirrored_value();

    i3c_env_cfg_h.regBlockHandle.wdatab_inst.mirror(status, UVM_NO_CHECK);


    i3c_env_cfg_h.regBlockHandle.ctrl_inst.direction.set(1'b0);

    i3c_env_cfg_h.regBlockHandle.ctrl_inst.start.set(1'b1);

    i3c_env_cfg_h.regBlockHandle.ctrl_inst.update(status);

    #5000;


    i3c_env_cfg_h.regBlockHandle.ctrl_inst.direction.set(1'b1);

    i3c_env_cfg_h.regBlockHandle.ctrl_inst.start.set(1'b1);

    i3c_env_cfg_h.regBlockHandle.ctrl_inst.update(status);

    #5000;

    i3c_env_cfg_h.regBlockHandle.rdatab_inst.read(status, rdata);


  endtask

endclass

`endif
