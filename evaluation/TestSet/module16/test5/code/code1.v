module CLA_10bit #(
    parameter width=10
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_10,
    output wire g_1_10
);

    wire c8;
    wire p_1_8, g_1_8;
    wire p_9_10, g_9_10;

    CLA_8bit #(.width(8)) u0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .cin(cin),
        .S(S[8:1]),
        .cout(c8),
        .p_1_8(p_1_8),
        .g_1_8(g_1_8)
    );
    CLA_2bit #(.width(2)) u1 (
        .A(A[10:9]),
        .B(B[10:9]),
        .cin(c8),
        .S(S[10:9]),
        .cout(cout),
        .p_1_2(p_9_10),
        .g_1_2(g_9_10)
    );
    assign p_1_10 = p_1_8 & p_9_10;
    assign g_1_10 = g_9_10|(g_1_8&p_9_10);
endmodule
