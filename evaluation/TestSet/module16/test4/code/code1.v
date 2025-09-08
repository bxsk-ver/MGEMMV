module CLA_12bit #(
    parameter width=12
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_12,
    output wire g_1_12
);

    wire c8;
    wire p_1_8, g_1_8;
    wire p_9_12, g_9_12;

    CLA_8bit #(.width(8)) u0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .cin(cin),
        .S(S[8:1]),
        .cout(c8),
        .p_1_8(p_1_8),
        .g_1_8(g_1_8)
    );
    CLA_4bit #(.width(4)) u1 (
        .A(A[12:9]),
        .B(B[12:9]),
        .cin(c8),
        .S(S[12:9]),
        .cout(cout),
        .p_1_4(p_9_12),
        .g_1_4(g_9_12)
    );
    assign p_1_12 = p_1_8 & p_9_12;
    assign g_1_12 = g_9_12|(g_1_8&p_9_12);
endmodule
