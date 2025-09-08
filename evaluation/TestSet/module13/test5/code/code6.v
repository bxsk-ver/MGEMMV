module GP_Gen_1_1 #(
    parameter width=1
)(
    input wire p,
    input wire g,
    output wire P,
    output wire G
);
    assign P = p;
    assign G = g;
endmodule
