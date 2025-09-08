
module Multi_Booth_signed #(
    parameter width=23
    )(
    input wire signed [width:1] A,  
    input wire signed [width:1] B,  
    output wire signed [width*2:1] P
    );
    assign P = A * B;
endmodule
