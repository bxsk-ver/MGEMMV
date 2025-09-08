module CLA_16bit #(
    parameter width=16
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_16,
    output wire g_1_16
);

    wire c8;
    wire p_1_8, g_1_8;
    wire p_9_16, g_9_16;

    CLA_8bit #(.width(8)) u0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .cin(cin),
        .S(S[8:1]),
        .cout(c8),
        .p_1_8(p_1_8),
        .g_1_8(g_1_8)
    );
    CLA_8bit #(.width(8)) u1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .cin(c8),
        .S(S[16:9]),
        .cout(cout),
        .p_1_8(p_9_16),
        .g_1_8(g_9_16)
    );
    assign p_1_16 = p_1_8 & p_9_16;
    assign g_1_16 = g_9_16|(g_1_8&p_9_16);
endmodule
