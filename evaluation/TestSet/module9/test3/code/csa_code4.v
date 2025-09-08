
module CSA_3to2_21_22_21 #(
    parameter A_width=21,
    parameter B_width=22,
    parameter C_width=21
)(
    input wire [A_width:1] A,
    input wire [B_width:1] B,
    input wire [C_width:1] C,
    output wire [B_width:1] S,
    output wire [C_width+1:1] Cout
);
    genvar i;
    generate
        for (i=1; i<C_width+1; i=i+1) begin
            assign {Cout[i+1], S[i]} = A[i] + B[i] + C[i];
        end
    endgenerate
    assign S[B_width] = B[B_width];
    assign Cout[1] = 1'b0;
endmodule
