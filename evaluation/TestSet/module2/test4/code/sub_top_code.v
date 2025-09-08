module GP_Gen_1_21 #(
    parameter width=21
)( 
    input wire [width:1] p,
    input wire [width:1] g,
    output wire [width:1] P,
    output wire [width:1] G
);
    wire p_17_21, p_17_20, p_17_19, p_17_18, p_17_17;
    wire g_17_21, g_17_20, g_17_19, g_17_18, g_17_17;
    GP_Gen_1_16 #(.width(16)) u0 (.p(p[16:1]), .g(g[16:1]), .P(P[16:1]), .G(G[16:1]));
    GP_Gen_1_5 #(.width(5)) u1 (.p(p[21:17]), .g(g[21:17]), .P({p_17_21, p_17_20, p_17_19, p_17_18, p_17_17}), .G({g_17_21, g_17_20, g_17_19, g_17_18, g_17_17}));
    assign P[17] = P[16] & p_17_17;
    assign G[17] = g_17_17 | (G[16] & p_17_17);
    assign P[18] = P[16] & p_17_18;
    assign G[18] = g_17_18 | (G[16] & p_17_18);
    assign P[19] = P[16] & p_17_19;
    assign G[19] = g_17_19 | (G[16] & p_17_19);
    assign P[20] = P[16] & p_17_20;
    assign G[20] = g_17_20 | (G[16] & p_17_20);
    assign P[21] = P[16] & p_17_21;
    assign G[21] = g_17_21 | (G[16] & p_17_21);

endmodule
