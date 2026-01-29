`include "uvm_macros.svh"
import uvm_pkg::*;



class sha256_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(sha256_sequence_item, sha256_scoreboard) mon_ap; //receive transcation from  monitor
    
    `uvm_component_utils(sha256_scoreboard)
    
    int pass,total;
    
    sha256_sequence_item shaitems[$];
    
//    sha256_reference_model refm;

function new (string name = "sha256_scoreboard", uvm_component parent = null);
    super.new(name,parent);
    mon_ap = new("mon_ap",this);
    pass = 0;
    total = 0;
    
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


task run_phase(uvm_phase phase);
super.run_phase(phase);

forever begin
sha256_sequence_item sha;
wait(shaitems.size()!=0);
sha = shaitems.pop_front;
compare(sha);
end


endtask : run_phase



task write(sha256_sequence_item tr);

shaitems.push_back(tr);

endtask : write
task compare(sha256_sequence_item tr);
    
    
    bit [255:0] expected_digest;
    //call reference model
    sha_compute(tr.data_in, tr.byte_valid, expected_digest);
    
    
    if(tr.digest !== expected_digest)begin
        `uvm_error("SCOREBOARD", $sformatf("NOT MATCHED! DUT=%h REF=%h",tr.digest,expected_digest))
     end else begin
        `uvm_info("SCOREBOARD",$sformatf("HASH MATCHED! .Digest=%h",tr.digest),UVM_LOW)
        pass++;
        end
        total++;
        
endtask




endclass

import "DPI-C" function void sha256_hash(
        input string message,
        input int msg_len,
        output byte hash[32]
    );
