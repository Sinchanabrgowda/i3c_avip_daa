/*
`ifndef TOP_VIRTUAL_BASE_SEQ_INCLUDED_
`define TOP_VIRTUAL_BASE_SEQ_INCLUDED_

class top_virtual_base_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(top_virtual_base_seq)

  // p_sequencer declaration — gives access to sequencer handles
  `uvm_declare_p_sequencer(top_virtual_sequencer) 

  uvm_status_e   status;
  uvm_reg_data_t rdata;
  bit            sdr_done;

  // env config handle — gives access to regBlockHandle
  i3c_env_config i3c_env_cfg_h; 

  function new(string name = "top_virtual_base_seq");
    super.new(name);
  endfunction

  // get config in body
  virtual task body();
    if(!uvm_config_db #(i3c_env_config)::get(null, get_full_name(), "i3c_env_config", i3c_env_cfg_h))
      `uvm_fatal(get_type_name(), "Cannot get i3c_env_cfg_h from config_db")
  endtask

endclass
`endif
*/

`ifndef TOP_VIRTUAL_BASE_SEQ_INCLUDED_
`define TOP_VIRTUAL_BASE_SEQ_INCLUDED_

class top_virtual_base_seq extends
  uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(top_virtual_base_seq)
  `uvm_declare_p_sequencer(top_virtual_sequencer)

  // Config handle accessible to child sequences
  i3c_env_config i3c_env_cfg_h;


  function new(string name =
               "top_virtual_base_seq");

    super.new(name);

  endfunction


  task body();

    if(p_sequencer == null)
      `uvm_fatal("SEQ_NULL",
        "Virtual sequencer handle is NULL")


    // Pull config from sequencer
    i3c_env_cfg_h =
      p_sequencer.i3c_env_cfg_h;


    if(i3c_env_cfg_h == null)
      `uvm_fatal("CFG_NULL",
        "i3c_env_cfg_h is NULL in base virtual sequence")


  endtask

endclass

`endif
