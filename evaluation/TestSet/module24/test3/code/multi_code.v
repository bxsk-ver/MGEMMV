
module Multi_signed #(
    parameter width=24
    )(
    input wire signed [width:1] A,  
    input wire signed [width:1] B,  
    output wire signed [width*2:1] P
    );
    assign P = A * B;
endmodule
