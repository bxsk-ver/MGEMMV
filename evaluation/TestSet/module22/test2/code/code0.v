
module Wino_ATZA_22_23_golden#(
    parameter data_width = 22
)(
    // din = 3 * 4
    input [data_width - 1:0] din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11,
    // dout = AT * dout * A
    output [data_width - 1:0] dout0, dout1, dout2, dout3
);

    // temp0 = AT * din
    wire [data_width - 1:0] temp0_0, temp0_1, temp0_2, temp0_3, temp0_4, temp0_5, temp0_6, temp0_7;

    assign temp0_0 = din0 + din4;
    assign temp0_1 = din1 + din5;
    assign temp0_2 = din2 + din6;
    assign temp0_3 = din3 + din7;
    assign temp0_4 = din0 - din4 + din8;
    assign temp0_5 = din1 - din5 + din9;
    assign temp0_6 = din2 - din6 + din10;
    assign temp0_7 = din3 - din7 + din11;

    // dout = temp0 * A
    assign dout0 = temp0_0 + temp0_1 + temp0_2;
    assign dout1 = temp0_1 - temp0_2 - temp0_3;
    assign dout2 = temp0_4 + temp0_5 + temp0_6;
    assign dout3 = temp0_5 - temp0_6 - temp0_7;

endmodule
