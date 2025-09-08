module FA_1bit #(
    parameter width=1
) (
    input wire A,
    input wire B,
    input wire cin,
    output wire S,
    output wire cout
);
    assign S = cin ^ A ^ B;
    assign cout = (A & B)|((A ^ B) & cin);
endmodule
