`ifndef I3C_TARGET_WRITEOPERATIONWITH8BITSDATA_SEQ_INCLUDED_
`define I3C_TARGET_WRITEOPERATIONWITH8BITSDATA_SEQ_INCLUDED_

class i3c_target_writeOperationWith8bitsData_seq extends i3c_target_base_seq;
  `uvm_object_utils(i3c_target_writeOperationWith8bitsData_seq)

  extern function new(string name = "i3c_target_writeOperationWith8bitsData_seq");
  extern task body();
endclass : i3c_target_writeOperationWith8bitsData_seq

function i3c_target_writeOperationWith8bitsData_seq::new(string name = "i3c_target_writeOperationWith8bitsData_seq");
  super.new(name);
endfunction : new

/*
task i3c_target_writeOperationWith8bitsData_seq::body();

//  super.body();

// GopalS:   req.i3c_target_agent_cfg_h = p_sequencer.i3c_target_agent_cfg_h;

// GopalS:   `uvm_info("DEBUG", $sformatf("address = %0x",
// GopalS:   p_sequencer.i3c_target_agent_cfg_h.slave_address_array[0]), UVM_NONE)

  req = i3c_target_tx::type_id::create("req"); 

  start_item(req);

    if(!req.randomize()) begin
      `uvm_error(get_type_name(), "Randomization failed")
    end
else begin
      `uvm_info(get_type_name(), $sformatf("Randomization SUCCESS - req contents below"), UVM_NONE)
      req.print();
    end
  
  finish_item(req);
`uvm_info(get_type_name(), "finish_item returned - item sent to driver", UVM_NONE)
endtask:body
  */

task i3c_target_writeOperationWith8bitsData_seq::body();
  req = i3c_target_tx::type_id::create("req");
  start_item(req);

    `uvm_info(get_type_name(), "Before randomization - req created", UVM_NONE)

    // targetAddress is NOT rand - assign directly before randomize
    //req.targetAddress = 7'h68;
req.targetAddress = p_sequencer.i3c_target_agent_cfg_h.targetAddress;

req.operation     = WRITE;

    if(!req.randomize() with {
        targetAddressStatus == ACK;   // override the 60% NACK bias
    }) begin
      `uvm_error(get_type_name(), "Randomization failed")
    end else begin
      // writeDataStatus size is soft==128, override to match transfer len=1
    //  req.writeDataStatus    = new[1];
    //  req.writeDataStatus[0] = ACK;
 req.writeDataStatus = new[17];
    foreach(req.writeDataStatus[i])
      req.writeDataStatus[i] = ACK;
      
`uvm_info(get_type_name(), "Randomization SUCCESS - after overrides", UVM_NONE)
      req.print();
    end

  finish_item(req);
  `uvm_info(get_type_name(), "finish_item returned - item sent to driver", UVM_NONE)
endtask : body

`endif

