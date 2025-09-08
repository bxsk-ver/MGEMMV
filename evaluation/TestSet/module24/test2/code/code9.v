module GP_Gen_1_17 #(
    parameter width=17
)( 
    input wire [width:1] p,
    input wire [width:1] g,
    output wire [width:1] P,
    output wire [width:1] G
);
    wire p_17_17;
    wire g_17_17;
    GP_Gen_1_16 #(.width(16)) u0 (.p(p[16:1]), .g(g[16:1]), .P(P[16:1]), .G(G[16:1]));
    GP_Gen_1_1 #(.width(1)) u1 (.p(p[17]), .g(g[17]), .P({p_17_17}), .G({g_17_17}));
    assign P[17] = P[16] & p_17_17;
    assign G[17] = g_17_17 | (G[16] & p_17_17);

endmodule
