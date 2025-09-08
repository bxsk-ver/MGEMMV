
module PE_row #(
    parameter data_width = 20,
    parameter  w_tile_column_size = 2
    )
	(
	// interface to system
    input wire clk,                         
    input wire rst_n,                       
	input wire w_en,
	input wire w_compute,
	// interface to PE array .....
	input wire [data_width - 1 :0] active_left,
    output wire [data_width - 1 :0] active_right,
	input wire [data_width * w_tile_column_size - 1 :0] in_weight_above,
	output wire [data_width * w_tile_column_size - 1 :0] out_weight_below,

	input wire [data_width * 2 * w_tile_column_size - 1 : 0] in_sum,
	output wire [data_width * 2 * w_tile_column_size - 1 : 0] out_sum
	);
	wire [data_width * (w_tile_column_size + 1) - 1 :0] active_right_temp;

    assign active_right_temp [data_width - 1 : 0] = active_left;
	genvar i;
    generate
        for(i = w_tile_column_size - 1; i >= 0; i = i - 1) begin //w_tile_column_size PE
            PE #(
            .data_width(data_width)
            )
            PE_unit0(
            .clk(clk),
            .rst_n(rst_n),
            .w_en(w_en),
            .w_compute(w_compute),
            .active_left(active_right_temp[(i+1) * data_width - 1 : i * data_width]),
            .active_right(active_right_temp[(i+2) * data_width - 1 : (i+1) * data_width]),
            .in_sum(in_sum[(i+1) * data_width * 2 - 1 : i * data_width * 2]),
            .out_sum(out_sum[(i+1) * data_width * 2 - 1 : i * data_width * 2]),
            .in_weight_above(in_weight_above[(i+1) * data_width - 1 : i * data_width]),
            .out_weight_below(out_weight_below[(i+1) * data_width - 1 : i * data_width])
            );    
        end 
    endgenerate
    assign active_right = active_right_temp [data_width * (w_tile_column_size + 1) - 1 : data_width * w_tile_column_size - 1];
endmodule
