
module Wino_BTDB_22_21_golden#(
    parameter data_width = 23
    )
    (
    // din = 3 * 2
    input wire [data_width - 1 : 0] din0, din1, din2, din3, din4, din5,
    // dout = BT * D * B
    output wire [data_width - 1 : 0] dout0, dout1, dout2, dout3, dout4, dout5
    );

    wire [data_width - 1:0] temp0_0, temp0_1, temp0_2, temp0_3, temp0_4, temp0_5;

    // temp0 = BT * d
    assign temp0_0 = din0 + din2;
    assign temp0_1 = din1 + din3;

    assign temp0_2 = din2 - din0;
    assign temp0_3 = din3 - din1;

    assign temp0_4 = din4 - din0;
    assign temp0_5 = din5 - din1;

    // dout = temp0 * B
    assign dout0 = temp0_0;
    assign dout1 = temp0_1;

    assign dout2 = temp0_2;
    assign dout3 = temp0_3;
    
    assign dout4 = temp0_4;
    assign dout5 = temp0_5;

endmodule

