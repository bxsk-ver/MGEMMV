module C_Skip_A_14bit #(
    parameter width=14
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);

    wire c8;
    wire c12;

    C_Skip_A_8bit #(.width(8)) u0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .cin(cin),
        .S(S[8:1]),
        .cout(c8)
    );
    C_Skip_A_4bit #(.width(4)) u1 (
        .A(A[12:9]),
        .B(B[12:9]),
        .cin(c8),
        .S(S[12:9]),
        .cout(c12)
    );
    C_Skip_A_2bit #(.width(2)) u2 (
        .A(A[14:13]),
        .B(B[14:13]),
        .cin(c12),
        .S(S[14:13]),
        .cout(cout)
    );

endmodule
