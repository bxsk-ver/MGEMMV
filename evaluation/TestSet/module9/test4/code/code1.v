module C_Sel_A_21bit #(
    parameter width=21
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);

    wire c16;
    wire c20;

    C_Sel_A_16bit #(.width(16)) u0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(cin),
        .S(S[16:1]),
        .cout(c16)
    );
    C_Sel_A_4bit #(.width(4)) u1 (
        .A(A[20:17]),
        .B(B[20:17]),
        .cin(c16),
        .S(S[20:17]),
        .cout(c20)
    );
    C_Sel_A_1bit #(.width(1)) u2 (
        .A(A[21:21]),
        .B(B[21:21]),
        .cin(c20),
        .S(S[21:21]),
        .cout(cout)
    );

endmodule
