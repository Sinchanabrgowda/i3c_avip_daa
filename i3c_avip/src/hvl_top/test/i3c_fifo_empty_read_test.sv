class i3c_fifo_empty_read_test extends i3c_base_test;
  `uvm_component_utils(i3c_fifo_empty_read_test)
  
  i3c_fifo_full_read_virtual_seq i3cfifofullread;
 
  function new(string name="i3c_fifo_empty_read_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    `uvm_info(get_type_name(),
              "Starting ONLY i3c_fifo_full_read_virtual_seq",
              UVM_LOW)
    
    i3cfifofullread = i3c_fifo_full_read_virtual_seq::type_id::create("i3cfifofullread");
    
    i3cfifofullread.i3c_env_cfg_h = i3c_env_cfg_h;
    i3cfifofullread.start(i3c_env_h.top_virtual_seqr_h);
    
    #50us;
    
    phase.drop_objection(this);
  endtask
  
endclass : i3c_fifo_empty_read_test
