module GP_Gen_1_10 #(
    parameter width=10
)( 
    input wire [width:1] p,
    input wire [width:1] g,
    output wire [width:1] P,
    output wire [width:1] G
);
    wire p_9_10, p_9_9;
    wire g_9_10, g_9_9;
    GP_Gen_1_8 #(.width(8)) u0 (.p(p[8:1]), .g(g[8:1]), .P(P[8:1]), .G(G[8:1]));
    GP_Gen_1_2 #(.width(2)) u1 (.p(p[10:9]), .g(g[10:9]), .P({p_9_10, p_9_9}), .G({g_9_10, g_9_9}));
    assign P[9] = P[8] & p_9_9;
    assign G[9] = g_9_9 | (G[8] & p_9_9);
    assign P[10] = P[8] & p_9_10;
    assign G[10] = g_9_10 | (G[8] & p_9_10);

endmodule
