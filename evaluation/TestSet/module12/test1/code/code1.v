module CLA_24bit #(
    parameter width=24
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_24,
    output wire g_1_24
);

    wire c16;
    wire p_1_16, g_1_16;
    wire p_17_24, g_17_24;

    CLA_16bit #(.width(16)) u0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(cin),
        .S(S[16:1]),
        .cout(c16),
        .p_1_16(p_1_16),
        .g_1_16(g_1_16)
    );
    CLA_8bit #(.width(8)) u1 (
        .A(A[24:17]),
        .B(B[24:17]),
        .cin(c16),
        .S(S[24:17]),
        .cout(cout),
        .p_1_8(p_17_24),
        .g_1_8(g_17_24)
    );
    assign p_1_24 = p_1_16 & p_17_24;
    assign g_1_24 = g_17_24|(g_1_16&p_17_24);
endmodule
