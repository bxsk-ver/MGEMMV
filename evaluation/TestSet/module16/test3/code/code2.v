
module GP_Gen_1_10 #(
    parameter width=10 
    )(
    input wire [width:1] p,
    input wire [width:1] g,
    output wire [width:1] P,
    output wire [width:1] G
    );
    wire [width:1] P_L1, G_L1;
    wire [width:1] P_L2, G_L2;
    wire [width:1] P_L3, G_L3;
    wire [width:1] P_L4, G_L4;
    genvar i1, i2, i3;
    genvar j1, j2;
    generate
        for (i1=1; i1<width+1; i1=i1+1) begin
            if (i1 % 2 == 0) begin
                assign P_L1[i1] = p[i1-1] & p[i1];
                 assign G_L1[i1] = g[i1] | (g[i1-1] & p[i1]);
            end else begin
                assign P_L1[i1] = p[i1];
                assign G_L1[i1] = g[i1];
            end
        end
        for (i2=1; i2<width+1; i2=i2+1) begin
            if (i2 % 4 == 0) begin
                assign P_L2[i2] = P_L1[i2-2] & P_L1[i2];
                assign G_L2[i2] = G_L1[i2] | (G_L1[i2-2] & P_L1[i2]);
            end else begin
                assign P_L2[i2] = P_L1[i2];
                assign G_L2[i2] = G_L1[i2];
            end
        end
        for (i3=1; i3<width+1; i3=i3+1) begin
            if (i3 % 8 == 0) begin
                assign P_L3[i3] = P_L2[i3-4] & P_L2[i3];
                assign G_L3[i3] = G_L2[i3] | (G_L2[i3-4] & P_L2[i3]);
            end else begin
                assign P_L3[i3] = P_L2[i3];
                assign G_L3[i3] = G_L2[i3];
            end
        end
        for (j2=1; j2<width+1; j2= j2+1) begin
            if (((j2-6) >= 0) && ((j2-6) % 4 == 0)) begin
                assign P_L4[j2] = P_L3[j2-2] & P_L3[j2];
                assign G_L4[j2] = G_L3[j2] | (G_L3[j2-2] & P_L3[j2]);
            end else begin
                assign P_L4[j2] = P_L3[j2];
                assign G_L4[j2] = G_L3[j2];
            end
        end

        for (j1=1; j1<width+1; j1=j1+1) begin
            if (((j1-3) >= 0) && ((j1-3) % 2 == 0)) begin
                assign P[j1] = P_L4[j1-1] & P_L4[j1];
                assign G[j1] = G_L4[j1] | (G_L4[j1-1] & P_L4[j1]);
            end else begin
                assign P[j1] = P_L4[j1];
                assign G[j1] = G_L4[j1];
            end
        end
    endgenerate
endmodule