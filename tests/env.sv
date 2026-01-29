`include "uvm_macros.svh"
import uvm_pkg::*;

class sha256_env extends uvm_env;

`uvm_component_utils(sha256_env)

    sha256_agent agnt;
    sha256_scoreboard sb;
    uvm_sequencer #(sha256_sequence_item) seqr;
    
    function new(string name = "sha256_env",uvm_component parent = null);
        super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        agnt = sha256_agent::type_id::create("agnt",this);
        sb = sha256_scoreboard::type_id::create("sb",this);
        endfunction
        
     function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
        mon.mon_ap.connect(sb.sb_ap);
    endfunction
    endclass
    
    
    
