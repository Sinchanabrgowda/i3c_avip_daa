
`ifndef I3C_TARGET_READOPERATIONWITH8BITSDATA_SEQ_INCLUDED_ 
`define I3C_TARGET_READOPERATIONWITH8BITSDATA_SEQ_INCLUDED_

class i3c_target_readOperationWith8bitsData_seq extends i3c_target_base_seq;
  `uvm_object_utils(i3c_target_readOperationWith8bitsData_seq)
 int unsigned num_bytes = 1; 

   extern function new(string name = "i3c_target_readOperationWith8bitsData_seq");
   extern task body();
endclass : i3c_target_readOperationWith8bitsData_seq

function i3c_target_readOperationWith8bitsData_seq::new(string name = "i3c_target_readOperationWith8bitsData_seq");
  super.new(name);
endfunction : new

/*
task i3c_target_readOperationWith8bitsData_seq::body();

  req = i3c_target_tx::type_id::create("req");

  start_item(req);

    `uvm_info(get_type_name(), "Before randomization - req created", UVM_NONE)

    // Address is NOT rand → assign before randomize
   // req.targetAddress = 7'h68;
req.targetAddress = p_sequencer.i3c_target_agent_cfg_h.targetAddress;
    // Force READ operation
    req.operation = READ;

     if(!req.randomize() with {
         targetAddressStatus == ACK;

     })

//  if(!req.randomize())

      begin

        `uvm_error(get_type_name(), "Randomization failed")

    end
    else begin
req.readData = new[1];
    req.readData[0] = 8'h0;

foreach(req.readData[i]) begin
  req.readData[i] = i;  // or randomize: 0x00, 0x01, 0x02, ... 0x0F
end     
  
 `uvm_info(get_type_name(),
        "Randomization SUCCESS - after overrides", UVM_NONE)

        req.print();

    end

  finish_item(req);

  `uvm_info(get_type_name(),
  "finish_item returned - item sent to driver", UVM_NONE)

endtask : body
*/

task i3c_target_readOperationWith8bitsData_seq::body();
  req = i3c_target_tx::type_id::create("req");
  start_item(req);

  `uvm_info(get_type_name(), "Before randomization - req created", UVM_NONE)

  req.targetAddress = p_sequencer.i3c_target_agent_cfg_h.targetAddress;
  req.operation     = READ;

  if(!req.randomize() with {
    targetAddressStatus == ACK;
  }) begin
    `uvm_error(get_type_name(), "Randomization failed")
  end else begin

    // ✅ FIX — size must match what controller expects (transfer_len)
    // BEFORE: req.readData = new[1];  ← only 1 byte, wrong!
    // AFTER:  size driven by num_bytes field set from virtual seq
    req.readData = new[num_bytes];
    foreach(req.readData[i])
      req.readData[i] = 8'h0; // target drives 0x00 as read data
                               // change if you want specific values

    `uvm_info(get_type_name(),
      $sformatf("Read seq ready: %0d bytes", num_bytes), UVM_LOW)
    req.print();
  end

  finish_item(req);
  `uvm_info(get_type_name(),
    "finish_item returned - item sent to driver", UVM_NONE)
endtask : body

`endif

