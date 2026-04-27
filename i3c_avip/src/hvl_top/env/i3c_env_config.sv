`ifndef I3C_ENV_CONFIG_INCLUDED_
`define I3C_ENV_CONFIG_INCLUDED_

class i3c_env_config extends uvm_object;
  `uvm_object_utils(i3c_env_config)

  // ── Existing fields ──────────────────────────
  bit                          has_scoreboard        = 1;
  bit                          has_virtual_sequencer = 1;
  int                          no_of_controllers;
  int                          no_of_targets;
  i3c_controller_agent_config  i3c_controller_agent_cfg_h[];
  i3c_target_agent_config      i3c_target_agent_cfg_h[];
  writeReadMode_e              writeReadMode_h;
  i3c_ral_reg_block            regBlockHandle;

  // ✅ NEW: DAA environment knobs
  // Set has_daa=1 in the test to enable DAA sequences and
  // DAA-aware scoreboard checking.
  bit                          has_daa               = 0;

  // ✅ NEW: number of devices expected to complete DAA
  // Used by the scoreboard to know when the DAA round is done.
  // Defaults to no_of_targets when not explicitly set.
  int                          no_of_daa_devices     = 0;

  extern function new(string name = "i3c_env_config");
  extern function void do_print(uvm_printer printer);

endclass : i3c_env_config


function i3c_env_config::new(string name = "i3c_env_config");
  super.new(name);
endfunction : new


function void i3c_env_config::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("has_scoreboard",
    has_scoreboard,        1,                    UVM_DEC);
  printer.print_field("has_virtual_sequencer",
    has_virtual_sequencer, 1,                    UVM_DEC);
  printer.print_field("no_of_controllers",
    no_of_controllers,     $bits(no_of_controllers), UVM_DEC);
  printer.print_field("no_of_targets",
    no_of_targets,         $bits(no_of_targets),  UVM_DEC);

  // NEW fields
  printer.print_field("has_daa",
    has_daa,               1,                    UVM_DEC);
  printer.print_field("no_of_daa_devices",
    no_of_daa_devices,     $bits(no_of_daa_devices), UVM_DEC);
endfunction : do_print

`endif
