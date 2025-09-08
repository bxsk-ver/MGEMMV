module PPA_Kogge_Stone_16bit #(
    parameter width=16
)(
    input wire [width-1:0] A,
    input wire [width-1:0] B,
    input wire cin,
    output wire [width-1:0] S,
    output wire cout
);
    wire [width-1:0] p, g;
    wire [width-1:0] P, G;
    wire [width:0] c_temp;

    assign c_temp[0] = cin;
    assign p = A ^ B;
    assign g = A & B;

    GP_Gen_1_16 #(.width(16)) u0 (
        .p(p),
        .g(g),
        .P(P),
        .G(G)
    );

    genvar i;
    generate
        for (i = 1; i < width + 1; i = i + 1) begin
            assign c_temp[i] = G[i-1] | (P[i-1] & c_temp[i - 1]);
        end
    endgenerate

    assign S = c_temp[width-1:0] ^ p;
    assign cout = c_temp[width];
endmodule
