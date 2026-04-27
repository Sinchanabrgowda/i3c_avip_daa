`ifndef I3C_TARGET_TX_INCLUDED_
`define I3C_TARGET_TX_INCLUDED_

class i3c_target_tx extends uvm_sequence_item;
  `uvm_object_utils(i3c_target_tx)

  // ──────────────────────────────────────────────
  // Existing SDR fields
  // ──────────────────────────────────────────────
  rand bit [DATA_WIDTH-1:0]       readData[];
  rand acknowledge_e              targetAddressStatus;
  rand acknowledge_e              writeDataStatus[];
       operationType_e            operation;
       bit [TARGET_ADDRESS_WIDTH-1:0] targetAddress;
       bit [DATA_WIDTH-1:0]       writeData[];
       acknowledge_e              readDataStatus[];
  rand bit [31:0]                 size;

  // ──────────────────────────────────────────────
  // NEW DAA fields (from i3c_daa_fsm)
  // ──────────────────────────────────────────────
  // Transaction type
  typedef enum bit {
    SDR = 1'b0,
    DAA = 1'b1
  } txn_type_e;

  rand txn_type_e   txn_type;          // SDR or DAA

  // DAA device identification fields
  rand bit [47:0]   pid;               // Provisional ID
  rand bit [7:0]    bcr;               // Bus Characteristics Register
  rand bit [7:0]    dcr;               // Device Characteristics Register
       bit [6:0]    dynamic_address;   // assigned by controller
       bit          daa_ack;           // ACK/NACK for dynamic address

  // ──────────────────────────────────────────────
  // Constraints — SDR (existing)
  // ──────────────────────────────────────────────
  constraint readDataSizeMax_c {
    soft readData.size() == MAXIMUM_BYTES;
  }

  constraint targetAddressStatus_c {
    targetAddressStatus dist {
      ACK  := 40,
      NACK := 60
    };
  }

  constraint writeDataStatusSize_c {
    soft writeDataStatus.size() == MAXIMUM_BYTES;
  }

  constraint writeDataStatusValue_c {
    foreach(writeDataStatus[i])
      soft writeDataStatus[i] == ACK;
  }

  // ──────────────────────────────────────────────
  // NEW Constraints — DAA
  // ──────────────────────────────────────────────

  // Default transaction type is SDR
  constraint txn_type_default_c {
    soft txn_type == SDR;
  }

  // PID must be non-zero for valid device
  constraint pid_valid_c {
    if(txn_type == DAA)
      pid != 48'h0;
  }

  // BCR bit fields per I3C spec
  // bit[2] = Max Data Speed Limitation
  // bit[6] = HDR Capable
  // bit[7] = Device Role (0=Target)
  constraint bcr_valid_c {
    if(txn_type == DAA)
      bcr[7] == 1'b0;   // Target device role
  }

  // ──────────────────────────────────────────────
  // Methods
  // ──────────────────────────────────────────────
  extern function new(string name = "i3c_target_tx");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs,
                                  uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function bit[1:0] getWriteDataStatus();
  extern function bit[1:0] getReadDataStatus();

endclass : i3c_target_tx


// ──────────────────────────────────────────────────
function i3c_target_tx::new(string name = "i3c_target_tx");
  super.new(name);
endfunction : new


// ──────────────────────────────────────────────────
function void i3c_target_tx::do_copy(uvm_object rhs);
  i3c_target_tx target_rhs;

  if(!$cast(target_rhs, rhs))
    `uvm_fatal("do_copy", "cast of rhs object failed")

  super.do_copy(rhs);

  // SDR fields
  targetAddress       = target_rhs.targetAddress;
  targetAddressStatus = target_rhs.targetAddressStatus;
  operation           = target_rhs.operation;
  writeData           = target_rhs.writeData;
  writeDataStatus     = target_rhs.writeDataStatus;
  readData            = target_rhs.readData;
  readDataStatus      = target_rhs.readDataStatus;

  //  DAA fields
  txn_type        = target_rhs.txn_type;
  pid             = target_rhs.pid;
  bcr             = target_rhs.bcr;
  dcr             = target_rhs.dcr;
  dynamic_address = target_rhs.dynamic_address;
  daa_ack         = target_rhs.daa_ack;

endfunction : do_copy


// ──────────────────────────────────────────────────
function bit i3c_target_tx::do_compare(uvm_object rhs,
                                        uvm_comparer comparer);
  i3c_target_tx target_rhs;

  if(!$cast(target_rhs, rhs)) begin
    `uvm_fatal("FATAL_DO_COMPARE_FAILED", "cast of rhs object failed")
    return 0;
  end

  return super.do_compare(rhs, comparer)        &&
    targetAddress       == target_rhs.targetAddress       &&
    targetAddressStatus == target_rhs.targetAddressStatus &&
    operation           == target_rhs.operation           &&
    writeData           == target_rhs.writeData           &&
    writeDataStatus     == target_rhs.writeDataStatus     &&
    readData            == target_rhs.readData            &&
    readDataStatus      == target_rhs.readDataStatus      &&
    // DAA fields
    txn_type        == target_rhs.txn_type        &&
    pid             == target_rhs.pid             &&
    bcr             == target_rhs.bcr             &&
    dcr             == target_rhs.dcr             &&
    dynamic_address == target_rhs.dynamic_address &&
    daa_ack         == target_rhs.daa_ack;

endfunction : do_compare


// ──────────────────────────────────────────────────
function void i3c_target_tx::do_print(uvm_printer printer);
  super.do_print(printer);

  // Print transaction type
  printer.print_string("txn_type", txn_type.name());

  if(txn_type == SDR) begin
    // ── SDR fields ──────────────────────────────
    printer.print_field("targetAddress",
      this.targetAddress, $bits(targetAddress), UVM_HEX);
    printer.print_string("targetAddressStatus",
      targetAddressStatus.name());
    printer.print_string("operation", operation.name());

    if(operation == WRITE) begin
      foreach(writeData[i])
        printer.print_field($sformatf("writeData[%0d]", i),
          this.writeData[i], $bits(writeData[i]), UVM_HEX);
      foreach(writeDataStatus[i])
        printer.print_string($sformatf("writeDataStatus[%0d]", i),
          writeDataStatus[i].name());
    end else begin
      foreach(readData[i])
        printer.print_field($sformatf("readData[%0d]", i),
          this.readData[i], $bits(readData[i]), UVM_HEX);
      foreach(readDataStatus[i])
        printer.print_string($sformatf("readDataStatus[%0d]", i),
          readDataStatus[i].name());
    end

  end else begin
    // ── DAA fields ──────────────────────────────
    printer.print_field("pid",
      this.pid, $bits(pid), UVM_HEX);
    printer.print_field("bcr",
      this.bcr, $bits(bcr), UVM_HEX);
    printer.print_field("dcr",
      this.dcr, $bits(dcr), UVM_HEX);
    printer.print_field("dynamic_address",
      this.dynamic_address, $bits(dynamic_address), UVM_HEX);
    printer.print_field("daa_ack",
      this.daa_ack, 1, UVM_BIN);
  end

endfunction : do_print


// ──────────────────────────────────────────────────
function bit[1:0] i3c_target_tx::getWriteDataStatus();
  int counterAckReceived;
  int counterNAckReceived;
  bit ack_value;
  bit nack_value;

  foreach(writeDataStatus[i]) begin
    if(writeDataStatus[i] == ACK)  counterAckReceived++;
    if(writeDataStatus[i] == NACK) counterNAckReceived++;
  end

  ack_value  = counterAckReceived  > 0 ? ACK  : NACK;
  nack_value = counterNAckReceived > 0 ? NACK : ACK;

  return ({ack_value, nack_value});

endfunction : getWriteDataStatus


// ──────────────────────────────────────────────────
function bit[1:0] i3c_target_tx::getReadDataStatus();
  int counterAckReceived;
  int counterNAckReceived;
  bit ack_value;
  bit nack_value;

  foreach(readDataStatus[i]) begin
    if(readDataStatus[i] == ACK)  counterAckReceived++;
    if(readDataStatus[i] == NACK) counterNAckReceived++;
  end

  ack_value  = counterAckReceived  > 0 ? ACK  : NACK;
  nack_value = counterNAckReceived > 0 ? NACK : ACK;

  return ({ack_value, nack_value});

endfunction : getReadDataStatus

`endif
