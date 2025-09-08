module C_Skip_A_20bit #(
    parameter width=20
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);

    wire c16;

    C_Skip_A_16bit #(.width(16)) u0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(cin),
        .S(S[16:1]),
        .cout(c16)
    );
    C_Skip_A_4bit #(.width(4)) u1 (
        .A(A[20:17]),
        .B(B[20:17]),
        .cin(c16),
        .S(S[20:17]),
        .cout(cout)
    );

endmodule
