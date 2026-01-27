`timescale 1ns / 1ps

module sha256_top (
    input  logic        clk,
    input  logic        rst_n,

    // Message input interface (example: from UART / TB)
    input  logic        msg_valid,
    input  logic [31:0] msg_word,

    // Final output
    output logic        hash_done,
    output logic [255:0] fin_hash
);

    // ------------------------------------------------------------
    // Internal signals
    // ------------------------------------------------------------

    // Padder / parser
    logic        block_valid;
    logic [511:0] block_512;

    // Controller
    logic        d_valid;
    logic        sched_en;
    logic [5:0]  round_idx;

    // Scheduler / ROM outputs
    logic [31:0] Wt;
    logic [31:0] Kt;

    // ------------------------------------------------------------
    // Padder & Parser
    // ------------------------------------------------------------
    padder_parser u_padder (
        .clk        (clk),
        .rst_n      (rst_n),
        .msg_valid  (msg_valid),
        .msg_word   (msg_word),
        .block_valid(block_valid),
        .block_out  (block_512)
    );

    // ------------------------------------------------------------
    // Controller FSM
    // ------------------------------------------------------------
    sha256_controller u_ctrl (
        .clk             (clk),
        .rst_n           (rst_n),
        .msg_block_valid (block_valid),
        .d_valid         (d_valid),
        .sched_en        (sched_en),
        .round_idx       (round_idx),
        .hash_done       (hash_done)
    );

    // ------------------------------------------------------------
    // Message Scheduler
    // ------------------------------------------------------------
    msg_scheduler u_sched (
        .clk        (clk),
        .rst_n      (rst_n),
        .sched_en  (sched_en),
        .round_idx (round_idx),
        .block_in  (block_512),
        .Wt_o      (Wt)
    );

    // ------------------------------------------------------------
    // SHA-256 K constant ROM
    // ------------------------------------------------------------
    sha256_k_rom u_krom (
        .addr (round_idx),
        .Kt_o (Kt)
    );

    // ------------------------------------------------------------
    // Hash Core (Compression Function)
    // ------------------------------------------------------------
    hash_core u_hash (
        .clk      (clk),
        .rst_n    (rst_n),
        .d_valid  (d_valid),
        .Kt_i     (Kt),
        .Wt_i     (Wt),
        .fin_hash (fin_hash)
    );

endmodule
