/*
`ifndef I3C_TARGET_COVERAGE_INCLUDED_
`define I3C_TARGET_COVERAGE_INCLUDED_

class i3c_target_coverage extends uvm_subscriber#(i3c_target_tx);
  `uvm_component_utils(i3c_target_coverage)

 covergroup target_covergroup with function sample (i3c_target_tx packet);
  option.per_instance = 1;
  
     
   OPERATION_CP : coverpoint packet.operation{
   option.comment = "Operation";
   bins OPERATION_WRITE = {0};
   bins OPERATION_READ = {1};
   }

  TARGET_ADDRESS_CP : coverpoint packet.targetAddress{
   option.comment = "TargetAddress";
   bins TARGETADDRESS = {[8:119]};
   illegal_bins RESERVEDADDRESS = {[0:7],[120:127]};
 }

   TARGET_ADDRESS_STATUS_CP : coverpoint packet.targetAddressStatus{
   option.comment = "targetAddressStatus";
   bins TARGET_ADDRESS_STATUS_ACK = {0};
   bins TARGET_ADDRESS_STATUS_NACK = {1};
  }

  WRITEDATA_CP : coverpoint packet.writeData.size()*DATA_WIDTH {
   option.comment = "writeData size of the packet transfer";
   bins WRITEDATA_WIDTH_1 = {8};
   bins WRITEDATA_WIDTH_2 = {16};
   bins WRITEDATA_WIDTH_3 = {24};
   bins WRITEDATA_WIDTH_4 = {32};
   bins WRITEDATA_WIDTH_5 = {64};
   bins WRITEDATA_WIDTH_6 = {[72:MAXIMUM_BITS]};
 }

  READDATA_CP : coverpoint packet.readData.size()*DATA_WIDTH {
   option.comment = "readData size of the packet transfer";
   bins READDATA_WIDTH_1 = {8};
   bins READDATA_WIDTH_2 = {16};
   bins READDATA_WIDTH_3 = {24};
   bins READDATA_WIDTH_4 = {32};
   bins READDATA_WIDTH_5 = {64};
   bins READDATA_WIDTH_6 = {[72:MAXIMUM_BITS]};
 }

 WRITEDATA_STATUS_CP : coverpoint packet.getWriteDataStatus() {
  option.comment = "writeData status";
  bins WRITEDATA_STATUS_ALL_ACK = {2'b00};
  bins WRITEDATA_STATUS_ALL_NACK = {2'b11};
  bins WRITEDATA_STATUS_MIX = {2'b01,2'b10};
}

  READDATA_STATUS_CP : coverpoint packet.getReadDataStatus() {
  option.comment = "readData status";
  bins READDATA_STATUS_ALL_ACK = {2'b00};
  bins READDATA_STATUS_ALL_NACK = {2'b11};
  bins READDATA_STATUS_MIX = {2'b01,2'b10};
}


OPERATION_CP_X_WRITEDATA_CP:cross OPERATION_CP, WRITEDATA_CP;

OPERATION_CP_X_READDATA_CP:cross OPERATION_CP, READDATA_CP;

  endgroup :target_covergroup


   extern function new(string name = "i3c_target_coverage", uvm_component parent = null);
  extern virtual function void display();
  extern virtual function void write(i3c_target_tx t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : i3c_target_coverage

function i3c_target_coverage::new(string name = "i3c_target_coverage", uvm_component parent = null);
  super.new(name, parent);
   target_covergroup = new(); 
endfunction : new

function void i3c_target_coverage::display();
  $display("");
  $display("--------------------------------------");
  $display("target COVERAGE");
  $display("--------------------------------------");
  $display("");
endfunction : display

function void i3c_target_coverage::write(i3c_target_tx t);
 `uvm_info("DEBUG_m_coverage", $sformatf("I3C_target_TX %0p",t),UVM_NONE);
    target_covergroup.sample(t);     
endfunction: write

function void i3c_target_coverage::report_phase(uvm_phase phase);
  display();
 `uvm_info(get_type_name(), $sformatf("target Agent Coverage = %0.2f %%",
                                       target_covergroup.get_coverage()), UVM_NONE);
endfunction: report_phase
`endif
*/

`ifndef I3C_TARGET_COVERAGE_INCLUDED_
`define I3C_TARGET_COVERAGE_INCLUDED_

class i3c_target_coverage extends uvm_subscriber#(i3c_target_tx);
  `uvm_component_utils(i3c_target_coverage)

  // ── SDR Covergroup ────────────────────────────────────────
  covergroup target_covergroup with function sample(i3c_target_tx packet);
    option.per_instance = 1;

    OPERATION_CP : coverpoint packet.operation {
      option.comment = "Operation";
      bins OPERATION_WRITE = {0};
      bins OPERATION_READ  = {1};
    }

    TARGET_ADDRESS_CP : coverpoint packet.targetAddress {
      option.comment    = "TargetAddress";
      bins TARGETADDRESS         = {[8:119]};
      illegal_bins RESERVEDADDRESS = {[0:7], [120:127]};
    }

    TARGET_ADDRESS_STATUS_CP : coverpoint packet.targetAddressStatus {
      option.comment = "targetAddressStatus";
      bins TARGET_ADDRESS_STATUS_ACK  = {0};
      bins TARGET_ADDRESS_STATUS_NACK = {1};
    }

    WRITEDATA_CP : coverpoint packet.writeData.size() * DATA_WIDTH {
      option.comment = "writeData size of the packet transfer";
      bins WRITEDATA_WIDTH_1 = {8};
      bins WRITEDATA_WIDTH_2 = {16};
      bins WRITEDATA_WIDTH_3 = {24};
      bins WRITEDATA_WIDTH_4 = {32};
      bins WRITEDATA_WIDTH_5 = {64};
      bins WRITEDATA_WIDTH_6 = {[72:MAXIMUM_BITS]};
    }

    READDATA_CP : coverpoint packet.readData.size() * DATA_WIDTH {
      option.comment = "readData size of the packet transfer";
      bins READDATA_WIDTH_1 = {8};
      bins READDATA_WIDTH_2 = {16};
      bins READDATA_WIDTH_3 = {24};
      bins READDATA_WIDTH_4 = {32};
      bins READDATA_WIDTH_5 = {64};
      bins READDATA_WIDTH_6 = {[72:MAXIMUM_BITS]};
    }

    WRITEDATA_STATUS_CP : coverpoint packet.getWriteDataStatus() {
      option.comment = "writeData status";
      bins WRITEDATA_STATUS_ALL_ACK  = {2'b00};
      bins WRITEDATA_STATUS_ALL_NACK = {2'b11};
      bins WRITEDATA_STATUS_MIX      = {2'b01, 2'b10};
    }

    READDATA_STATUS_CP : coverpoint packet.getReadDataStatus() {
      option.comment = "readData status";
      bins READDATA_STATUS_ALL_ACK  = {2'b00};
      bins READDATA_STATUS_ALL_NACK = {2'b11};
      bins READDATA_STATUS_MIX      = {2'b01, 2'b10};
    }

    OPERATION_CP_X_WRITEDATA_CP : cross OPERATION_CP, WRITEDATA_CP;
    OPERATION_CP_X_READDATA_CP  : cross OPERATION_CP, READDATA_CP;

  endgroup : target_covergroup

  // ── DAA Covergroup ────────────────────────────────────────
  covergroup daa_covergroup with function sample(i3c_target_tx packet);
    option.per_instance = 1;

    // Was the dynamic address assignment acknowledged?
    DAA_ACK_CP : coverpoint packet.daa_ack {
      option.comment = "DAA address assignment ACK/NACK";
      bins DAA_ACK  = {0};  // ACK  = address accepted
      bins DAA_NACK = {1};  // NACK = address rejected
    }

    // Dynamic address range — valid I3C dynamic addresses
    DAA_DYNADDR_CP : coverpoint packet.dynamic_address {
      option.comment = "Dynamic address assigned by controller";
      bins DYNADDR_LOW    = {[8:63]};    // lower half valid range
      bins DYNADDR_HIGH   = {[64:119]};  // upper half valid range
      illegal_bins DYNADDR_RESERVED = {[0:7], [120:127]};
    }

    // PID upper byte (manufacturer identifier) — 6 bytes total,
    // just bin the top byte as a presence check
    DAA_PID_TOP_BYTE_CP : coverpoint packet.pid[47:40] {
      option.comment = "PID top byte (manufacturer ID upper)";
      bins PID_NONZERO = {[1:255]};
      bins PID_ZERO    = {0};
    }

    // BCR bit7 — role: must be 0 for target
    DAA_BCR_ROLE_CP : coverpoint packet.bcr[7] {
      option.comment = "BCR[7]: 0=target 1=controller";
      bins TARGET_ROLE     = {0};
      bins CONTROLLER_ROLE = {1};
    }

    // BCR bit6 — advanced capabilities
    DAA_BCR_ADV_CP : coverpoint packet.bcr[6] {
      option.comment = "BCR[6]: advanced capabilities";
      bins ADV_CAP_OFF = {0};
      bins ADV_CAP_ON  = {1};
    }

    // BCR bit5 — virtual target support
    DAA_BCR_VIRTUAL_CP : coverpoint packet.bcr[5] {
      option.comment = "BCR[5]: virtual target";
      bins VIRTUAL_OFF = {0};
      bins VIRTUAL_ON  = {1};
    }

    // BCR bit4 — offline capable
    DAA_BCR_OFFLINE_CP : coverpoint packet.bcr[4] {
      option.comment = "BCR[4]: offline capable";
      bins OFFLINE_OFF = {0};
      bins OFFLINE_ON  = {1};
    }

    // BCR bit3 — IBI payload
    DAA_BCR_IBI_PAYLOAD_CP : coverpoint packet.bcr[3] {
      option.comment = "BCR[3]: IBI with payload";
      bins IBI_NO_PAYLOAD = {0};
      bins IBI_PAYLOAD    = {1};
    }

    // BCR bit2 — IBI request capable
    DAA_BCR_IBI_REQ_CP : coverpoint packet.bcr[2] {
      option.comment = "BCR[2]: IBI request capable";
      bins IBI_NOT_CAPABLE = {0};
      bins IBI_CAPABLE     = {1};
    }

    // BCR bits[1:0] — max data speed limitation
    DAA_BCR_SPEED_CP : coverpoint packet.bcr[1:0] {
      option.comment = "BCR[1:0]: max data speed";
      bins SPEED_NO_LIMIT    = {2'b00};
      bins SPEED_LIMIT_1     = {2'b01};
      bins SPEED_LIMIT_2     = {2'b10};
      bins SPEED_LIMIT_3     = {2'b11};
    }

    // DCR full byte — device characteristic register
    DAA_DCR_CP : coverpoint packet.dcr {
      option.comment = "DCR full byte";
      bins DCR_ZERO    = {0};
      bins DCR_NONZERO = {[1:255]};
    }

    // Cross: dynamic address with ACK result
    DAA_DYNADDR_X_ACK : cross DAA_DYNADDR_CP, DAA_ACK_CP;

    // Cross: BCR role with ACK result
    DAA_ROLE_X_ACK : cross DAA_BCR_ROLE_CP, DAA_ACK_CP;

  endgroup : daa_covergroup

  extern function new(string name = "i3c_target_coverage",
                      uvm_component parent = null);
  extern virtual function void display();
  extern virtual function void write(i3c_target_tx t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : i3c_target_coverage


// ─────────────────────────────────────────────────────────────
function i3c_target_coverage::new(
  string name = "i3c_target_coverage",
  uvm_component parent = null);

  super.new(name, parent);
  target_covergroup = new();
  daa_covergroup    = new();

endfunction : new


// ─────────────────────────────────────────────────────────────
function void i3c_target_coverage::display();
  $display("");
  $display("--------------------------------------");
  $display("target COVERAGE");
  $display("--------------------------------------");
  $display("");
endfunction : display


// ─────────────────────────────────────────────────────────────
// write() — dispatch to correct covergroup based on txn_type
// ─────────────────────────────────────────────────────────────
function void i3c_target_coverage::write(i3c_target_tx t);
  `uvm_info("DEBUG_m_coverage",
    $sformatf("I3C_target_TX %0p", t), UVM_NONE);

  case(t.txn_type)
    i3c_target_tx::SDR: begin
      // SDR: sample main covergroup
      // targetAddress=0 is broadcast (reserved) and must not
      // reach TARGET_ADDRESS_CP — only sample if address is valid
      if(t.targetAddress inside {[8:119]}) begin
        target_covergroup.sample(t);
      end else begin
        `uvm_info("DEBUG_m_coverage",
          $sformatf("SDR: skipping coverage sample for reserved/broadcast addr=0x%0x",
                    t.targetAddress), UVM_HIGH)
      end
    end

    i3c_target_tx::DAA: begin
      // DAA: sample dedicated DAA covergroup
      daa_covergroup.sample(t);
    end

    default: begin
      `uvm_warning("DEBUG_m_coverage",
        $sformatf("Unknown txn_type=%0s — not sampled", t.txn_type.name()))
    end
  endcase

endfunction: write


// ─────────────────────────────────────────────────────────────
function void i3c_target_coverage::report_phase(uvm_phase phase);
  display();

  `uvm_info(get_type_name(),
    $sformatf("target Agent SDR Coverage = %0.2f %%",
              target_covergroup.get_coverage()), UVM_NONE)

  `uvm_info(get_type_name(),
    $sformatf("target Agent DAA Coverage = %0.2f %%",
              daa_covergroup.get_coverage()), UVM_NONE)

  `uvm_info(get_type_name(),
    $sformatf("target Agent Total Coverage = %0.2f %%",
              (target_covergroup.get_coverage() +
               daa_covergroup.get_coverage()) / 2.0), UVM_NONE)

endfunction: report_phase

`endif
