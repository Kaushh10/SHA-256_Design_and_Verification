`include "uvm_macros.svh"
import uvm_pkg::*;

class sha256_driver extends uvm_driver #(sha256_sequence_item);
  virtual sha256_if vif;
  
    `uvm_component_utils(sha256_driver)
    
  function new(string name="sha256_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sha256_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for sha256_driver")
  endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase( phase);
endfunction:connect_phase


  task run_phase(uvm_phase phase);
    sha256_sequence_item tr;
    forever begin
      tr = sha256_sequence_item::type_id::create("tr");
      seq_item_port.get_next_item(tr);
    
      vif.data_in    <= tr.my_data;
      vif.byte_valid <= tr.my_data.size();
      vif.msg_valid  <= 1;
      vif.rst_n <= tr.rst_n;
      @(posedge vif.clk);
      seq_item_port.item_done();
    end
  endtask
endclass

