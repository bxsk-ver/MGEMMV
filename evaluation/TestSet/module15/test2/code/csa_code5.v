
module CSA_3to2_11_11_14 #(
    parameter A_width=11,
    parameter B_width=11,
    parameter C_width=14
)(
    input wire [A_width:1] A,
    input wire [B_width:1] B,
    input wire [C_width:1] C,
    output wire [C_width:1] S,
    output wire [B_width+1:1] Cout
);
    genvar i;
    generate
        for (i=1; i<B_width+1; i=i+1) begin
            assign {Cout[i+1], S[i]} = A[i] + B[i] + C[i];
        end
    endgenerate
    assign S[C_width:B_width+1] = C[C_width:B_width+1];
    assign Cout[1] = 1'b0;
endmodule
