
module CSA_3to2_18_19_19 #(
    parameter A_width=18,
    parameter B_width=19,
    parameter C_width=19
)(
    input wire [A_width:1] A,
    input wire [B_width:1] B,
    input wire [C_width:1] C,
    output wire [C_width:1] S,
    output wire [B_width+1:1] Cout
);
    genvar i, j;
    generate
        for (i=1; i<A_width+1; i=i+1) begin
            assign {Cout[i+1], S[i]} = A[i] + B[i] + C[i];
        end

        for (j=A_width+1; j<C_width+1; j=j+1) begin
            assign {Cout[j+1], S[j]} = C[j] + B[j];
        end
    endgenerate
    assign Cout[1] = 1'b0;
endmodule
