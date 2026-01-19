// ============================================================================
// SHA-256 Message Schedule Logic
//  - 16-word circular buffer (r0..r15)
//  - Implements Wt generation per FIPS-180-4
//  - One word per clock
//  - Matches provided datapath diagram exactly
// ============================================================================

module sha256_msg_sched (
    input  logic         clk,
    input  logic         rst_n,

    // Load interface
    input  logic         ld_i,      // Load initial message words
    input  logic [31:0]  M_i,       // Incoming 32-bit message word

    // Output
    output logic [31:0]  Wt_o       // Current W[t]
);

    // ------------------------------------------------------------------------
    // 16-word circular buffer
    // ------------------------------------------------------------------------
    logic [31:0] r [0:15];

    // ------------------------------------------------------------------------
    // Rotate right function (ASIC friendly)
    // ------------------------------------------------------------------------
    function automatic logic [31:0] rotr (
        input logic [31:0] x,
        input int unsigned n
    );
        rotr = (x >> n) | (x << (32 - n));
    endfunction

    // ------------------------------------------------------------------------
    // σ0 and σ1 functions (FIPS-180-4)
    // ------------------------------------------------------------------------
    logic [31:0] sigma0, sigma1;

    assign sigma0 = rotr(r[1], 7) ^ rotr(r[1], 18) ^ (r[1] >> 3);
    assign sigma1 = rotr(r[14], 17) ^ rotr(r[14], 19) ^ (r[14] >> 10);

    // ------------------------------------------------------------------------
    // W[t] computation
    // Wt = r0 + σ0 + r9 + σ1
    // ------------------------------------------------------------------------
    logic [31:0] W_next;
    assign W_next = r[0] + sigma0 + r[9] + sigma1;

    // Output tap
    assign Wt_o = r[0];

    // ------------------------------------------------------------------------
    // Circular buffer shift register
    // ------------------------------------------------------------------------
    integer i;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 16; i++)
                r[i] <= 32'd0;
        end
        else begin
            // Shift left
            for (i = 0; i < 15; i++)
                r[i] <= r[i+1];

            // Load or compute new word
            if (ld_i)
                r[15] <= M_i;       // Load initial message words
            else
                r[15] <= W_next;   // Expanded message word
        end
    end

endmodule
