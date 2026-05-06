`ifndef I3C_MULTI_WRITE_READ_BACK_TEST_INCLUDED_
`define I3C_MULTI_WRITE_READ_BACK_TEST_INCLUDED_

class i3c_multi_write_read_back_test extends i3c_base_test;
  `uvm_component_utils(i3c_multi_write_read_back_test)

  i3c_multi_write_read_back_seq multiWrRdSeq;

  function new(string name = "i3c_multi_write_read_back_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info(get_type_name(),
      "Starting 24-bit write/read coverage test", UVM_LOW)

    multiWrRdSeq =
      i3c_multi_write_read_back_seq::type_id::create("multiWrRdSeq");
    multiWrRdSeq.i3c_env_cfg_h = i3c_env_cfg_h;
    multiWrRdSeq.start(i3c_env_h.top_virtual_seqr_h);

    #50us;
    phase.drop_objection(this);
  endtask

endclass : i3c_multi_write_read_back_test

`endif
