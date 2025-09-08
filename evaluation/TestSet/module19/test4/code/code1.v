module C_Sel_A_18bit #(
    parameter width=18
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);

    wire c16;

    C_Sel_A_16bit #(.width(16)) u0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(cin),
        .S(S[16:1]),
        .cout(c16)
    );
    C_Sel_A_2bit #(.width(2)) u1 (
        .A(A[18:17]),
        .B(B[18:17]),
        .cin(c16),
        .S(S[18:17]),
        .cout(cout)
    );

endmodule
