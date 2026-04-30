class i3c_regression_test extends i3c_base_test;
  `uvm_component_utils(i3c_regression_test)

i3c_daa_virtual_seq daaSeq;
  i3c_sdr_write_virtual_seq        sdrWriteSeq;
  i3c_sdr_read_virtual_seq      sdrReadSeq;
  i3c_sdr_write_read_virtual_seq  sdrWriteReadSeq;
  i3c_sdr_write_read_write_read_virtual_seq  sdrWriteReadWriteReadSeq;
 i3c_invalid_addr_write_virtual_seq invalidAddrseq;
  i3c_fifo_full_write_virtual_seq fifofullSeq;
//i3c_sdr_or_daa_virtual_seq sdrordaaseq;
//   i3c_daa_virtual_seq daaSeq;


  function new(string name="i3c_regression_test.s", uvm_component parent=null);
    super.new(name, parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info(get_type_name(),
              "Starting Regression sequence",
              UVM_LOW)

 daaSeq = i3c_daa_virtual_seq::type_id::create("daaSeq");
    sdrWriteSeq = i3c_sdr_write_virtual_seq::type_id::create("sdrWriteSeq");
    sdrReadSeq        = i3c_sdr_read_virtual_seq::type_id::create("sdrReadSeq");
    sdrWriteReadSeq   = i3c_sdr_write_read_virtual_seq::type_id::create("sdrWriteReadSeq");
    sdrWriteReadWriteReadSeq =
    i3c_sdr_write_read_write_read_virtual_seq::type_id::create("sdrWriteReadWriteReadSeq");
invalidAddrseq = i3c_invalid_addr_write_virtual_seq ::type_id::create("invalidAddrseq");
    fifofullSeq = i3c_fifo_full_write_virtual_seq ::type_id::create("fifofullSeq");
//sdrordaaseq = i3c_sdr_or_daa_virtual_seq ::type_id::create("sdrordaaseq");

//     daaSeq = i3c_daa_virtual_seq::type_id::create("daaSeq");



daaSeq.i3c_env_cfg_h = i3c_env_cfg_h;
    sdrWriteSeq.i3c_env_cfg_h = i3c_env_cfg_h;
    sdrReadSeq.i3c_env_cfg_h        = i3c_env_cfg_h;
    sdrWriteReadSeq.i3c_env_cfg_h   = i3c_env_cfg_h;
    sdrWriteReadWriteReadSeq.i3c_env_cfg_h = i3c_env_cfg_h;
   invalidAddrseq.i3c_env_cfg_h = i3c_env_cfg_h;
   fifofullSeq.i3c_env_cfg_h = i3c_env_cfg_h;
//sdrordaaseq.i3c_env_cfg_h = i3c_env_cfg_h;

// daaSeq.i3c_env_cfg_h = i3c_env_cfg_h;


daaSeq.start(i3c_env_h.top_virtual_seqr_h);
    sdrWriteSeq.start(i3c_env_h.top_virtual_seqr_h);
    sdrReadSeq.start(i3c_env_h.top_virtual_seqr_h);
    sdrWriteReadSeq.start(i3c_env_h.top_virtual_seqr_h);
    sdrWriteReadWriteReadSeq.start(i3c_env_h.top_virtual_seqr_h);
    invalidAddrseq.start(i3c_env_h.top_virtual_seqr_h);
    fifofullSeq.start(i3c_env_h.top_virtual_seqr_h);
//sdrordaaseq.start(i3c_env_h.top_virtual_seqr_h);

//     daaSeq.start(i3c_env_h.top_virtual_seqr_h);
    
#50us;
    phase.drop_objection(this);

  endtask

endclass
