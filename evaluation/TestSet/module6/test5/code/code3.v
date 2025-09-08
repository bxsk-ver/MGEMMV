module C_Sel_A_3bit #(
    parameter width=3
) (
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);
    wire [width:1] S0, S1;
    wire cout0, cout1;
    assign {cout0, S0} = A + B + 1'b0;
    assign {cout1, S1} = A + B + 1'b1;
    assign S = cin ? S1 : S0;
    assign cout = cin ? cout1 : cout0;
endmodule
