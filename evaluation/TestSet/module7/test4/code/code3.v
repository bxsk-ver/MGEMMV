module CLA_2bit #(
    parameter width=2
) (
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_2,
    output wire g_1_2
);
    wire [width:1] p, g;
    wire [width:0] c_temp;
    assign c_temp[0] = cin;
    assign p = A ^ B;
    assign g = A & B;
    GP_Gen_1_2 #(.width(width)) u0 (.p(p), .g(g), .cin(c_temp[0]), .cout(c_temp[width:1]), .p_1_2(p_1_2), .g_1_2(g_1_2));
    assign S = c_temp[width-1:0] ^ p;
    assign cout = c_temp[width];
endmodule
