//A different approach to our Hashcore logic code
module hashcore(
    input logic clk,
    input logic rst_n,
    input bit load,
    
    // Inputs for this round
    input  logic [31:0] Kt_i,  // round constant
    input  logic [31:0] Wt_i,  // message schedule word

    //initial hash value
    input  logic [31:0] A_i, B_i, C_i, D_i, E_i, F_i, G_i, H_i,

    // Outputs
    output logic [31:0] A_o, B_o, C_o, D_o, E_o, F_o, G_o, H_o,
    output logic [255:0] finall,
    output logic done          // flag when all 64 rounds complete
);

// registers

logic [31:0] a, b, c, d, e, f, g, h;
logic [5:0]  round_cnt;  // counts 0..63

function automatic logic [31:0] ch(input logic [31:0] x,
                                    input logic [31:0] y,
                                    input logic [31:0] z);

    ch = (x & y) ^ (~x & z);

endfunction
    
endmodule
