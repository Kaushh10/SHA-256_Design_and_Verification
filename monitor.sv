`include "uvm_macros.svh"
import uvm_pkg::*;

class sha256_monitor extends uvm_monitor;
    virtual hash256 vif;
    uvm_analysis_port #(sha256_seq_item) anp;
    
      `uvm_component_utils(sha256_monitor)
    
    function new(string name = "sha256_monitor",uvm_component parent=null);
            super.new(name,parent);
            anp = new("anp",this);
     endfunction

        task run_phase(uvm_phase phase);
            sha256_seq_item tr;
            forever begin
            @(posedge vif.clk);
            if(vif.done)begin
                tr = sha256_seq_item::type_id::create("tr");
                tr.sha256_expected = vif.finall;
                    anp.write(tr);
               end
               end
           endtask
     endclass     
