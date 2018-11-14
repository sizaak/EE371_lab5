module N_fir #(parameter N=16) (reset, CLOCK_50, data_in, data_out);
	
	input logic reset, CLOCK_50;
	input logic [23:0] data_in;
	output logic [23:0] data_out;
	
	parameter DATA_SIZE = 24;
	
	logic rd, wr, empty, full;
	logic [23:0] w_data, r_data;
	//logic [23:0] s1, s2, s3;
	
	// Divide input by N
	assign w_data = data_in / N;
	
	assign rd = ~empty;
	assign wr = ~full;
	
	// Store in FIFO
	fifo #(.DATA_WIDTH(DATA_SIZE), .ADDR_WIDTH(N)) fifo_unit
   (.clk(CLOCK_50), .reset, .rd, .wr, .w_data, .empty, .full, .r_data);
	
	// Subtract
	assign s1 = w_data - r_data;
	
	// Add to accumulator
	assign s2 = s1 + s3;
	D_FF_24 accumulator (.q(s3), .d(s2), .reset, .clk(CLOCK_50));
	
	assign data_out = s2;
	
	
	always_ff @(posedge CLOCK_50) begin
		if(reset) // fill buffer all zeros
		else
	
	end
	
endmodule

module tb_N_fir();
	logic reset, CLOCK_50;
	logic [23:0] data_in, data_out;
	
	parameter SIZE = 16;
	
	N_fir #(.N(SIZE)) dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		CLOCK_50 <= 0;
		forever#(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50;
	end

	initial begin
		reset <= 1; @(posedge CLOCK_50);
		reset <= 0;
		for (int i = 0; i < SIZE; i++) 
			data_in <= 24'h000400; @(posedge CLOCK_50);
		for (int i = 0; i < SIZE/2; i++) begin
			data_in <= 24'h000800; @(posedge CLOCK_50);
			data_in <= 24'h000000; @(posedge CLOCK_50);
		end
		$stop;
	end

endmodule