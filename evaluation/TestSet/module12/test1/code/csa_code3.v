
module CSA_3to2_24_19_23 #(
    parameter A_width=24,
    parameter B_width=19,
    parameter C_width=23
)(
    input wire [A_width:1] A,
    input wire [B_width:1] B,
    input wire [C_width:1] C,
    output wire [A_width:1] S,
    output wire [C_width+1:1] Cout
);
    genvar i, j;
    generate
        for (i=1; i<B_width+1; i=i+1) begin
            assign {Cout[i+1], S[i]} = A[i] + B[i] + C[i];
        end
        for (j=B_width+1; j<C_width+1; j=j+1) begin
            assign {Cout[j+1], S[j]} = A[j] + C[j];
        end
    endgenerate
    assign S[A_width] = A[A_width];
    assign Cout[1] = 1'b0;
endmodule
