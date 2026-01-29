`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "test.sv"

module top_tb;

bit clk;


initial
forever #5 clk = ~clk;

sha256_if sif(.clk(clk));


top DUT (.clk(clk),
         .rst_n(sif.rst_n),
         .msg_valid(sif.msg_valid),
         .byte_valid(sif.byte_valid),
         .msg_word(sif.data_in),
         .hash_done(sif.hash_done),
         .fin_hash(sif.fin_hash)
         );
        

initial begin
uvm_config_db#(virtual sha256_if)::set(null,"*","vif",sif);
run_test("sha_test");
end



endmodule
