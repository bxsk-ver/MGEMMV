module GP_Gen_1_2 #(
    parameter width=2
)(
    input wire [width:1] p,
    input wire [width:1] g,
    output wire [width:1] P,
    output wire [width:1] G
);
    assign P[1] = p[1];
    assign P[2] = p[1] & p[2];

    assign G[1] = g[1];
    assign G[2] = g[2] | (g[1] & p[2]);
endmodule
