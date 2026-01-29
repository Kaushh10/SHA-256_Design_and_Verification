`include "uvm_macros.svh"
import uvm_pkg::*;

class sha256_monitor extends uvm_monitor;
  virtual sha256_if vif;
  uvm_analysis_port #(sha256_sequence_item) mon_ap;
  `uvm_component_utils(sha256_monitor)

  function new(string name="sha256_monitor", uvm_component parent=null);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sha256_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for sha256_monitor")
  endfunction

  task run_phase(uvm_phase phase);
    sha256_sequence_item tr;
    forever begin
      @(posedge vif.clk);
      if(vif.hash_done) begin
        tr = sha256_sequence_item::type_id::create("tr");
        tr.fin_hash = vif.fin_hash;
        tr.my_data = vif.data_in;
        tr.byte_enable = vif.byte_enable;
        mon_ap.write(tr);
      end
    end
  endtask
endclass
