`ifndef I3C_RX_FIFO_FULL_TEST_INCLUDED_
`define I3C_RX_FIFO_FULL_TEST_INCLUDED_

class i3c_rx_fifo_full_test extends i3c_base_test;
  `uvm_component_utils(i3c_rx_fifo_full_test)

  i3c_rx_fifo_full_virtual_seq rxFifoFullSeq;

  function new(string name = "i3c_rx_fifo_full_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info(get_type_name(),
      "Starting RX FIFO full test", UVM_LOW)

    rxFifoFullSeq =
      i3c_rx_fifo_full_virtual_seq::type_id::create("rxFifoFullSeq");
    rxFifoFullSeq.i3c_env_cfg_h = i3c_env_cfg_h;
    rxFifoFullSeq.start(i3c_env_h.top_virtual_seqr_h);

    #50us;
    phase.drop_objection(this);
  endtask

endclass
`endif
