module GP_Gen_1_12 #(
    parameter width=12
)( 
    input wire [width:1] p,
    input wire [width:1] g,
    output wire [width:1] P,
    output wire [width:1] G
);
    wire p_9_12, p_9_11, p_9_10, p_9_9;
    wire g_9_12, g_9_11, g_9_10, g_9_9;
    GP_Gen_1_8 #(.width(8)) u0 (.p(p[8:1]), .g(g[8:1]), .P(P[8:1]), .G(G[8:1]));
    GP_Gen_1_4 #(.width(4)) u1 (.p(p[12:9]), .g(g[12:9]), .P({p_9_12, p_9_11, p_9_10, p_9_9}), .G({g_9_12, g_9_11, g_9_10, g_9_9}));
    assign P[9] = P[8] & p_9_9;
    assign G[9] = g_9_9 | (G[8] & p_9_9);
    assign P[10] = P[8] & p_9_10;
    assign G[10] = g_9_10 | (G[8] & p_9_10);
    assign P[11] = P[8] & p_9_11;
    assign G[11] = g_9_11 | (G[8] & p_9_11);
    assign P[12] = P[8] & p_9_12;
    assign G[12] = g_9_12 | (G[8] & p_9_12);

endmodule
