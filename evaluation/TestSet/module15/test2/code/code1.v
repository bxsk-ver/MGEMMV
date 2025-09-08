module CLA_18bit #(
    parameter width=18
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_18,
    output wire g_1_18
);

    wire c16;
    wire p_1_16, g_1_16;
    wire p_17_18, g_17_18;

    CLA_16bit #(.width(16)) u0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(cin),
        .S(S[16:1]),
        .cout(c16),
        .p_1_16(p_1_16),
        .g_1_16(g_1_16)
    );
    CLA_2bit #(.width(2)) u1 (
        .A(A[18:17]),
        .B(B[18:17]),
        .cin(c16),
        .S(S[18:17]),
        .cout(cout),
        .p_1_2(p_17_18),
        .g_1_2(g_17_18)
    );
    assign p_1_18 = p_1_16 & p_17_18;
    assign g_1_18 = g_17_18|(g_1_16&p_17_18);
endmodule
