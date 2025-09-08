module C_Skip_A_3bit #(
    parameter width=3
) (
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);
    wire [width:1] p;
    wire cout_fa;
    assign p = A ^ B;
    assign {cout_fa, S} = A + B + cin;
    assign cout = &p ? cin : cout_fa;
endmodule
