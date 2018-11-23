module ate(clk,reset,pix_data,bin,threshold);
input clk;
input reset;
input [7:0] pix_data;
output reg bin;
output reg [7:0] threshold;

reg [7:0] buffer [64:0]; 
reg [6:0] count;  
reg [7:0] min;
reg [7:0] max;
reg [4:0] block_count;
reg [8:0] tmp;
integer i;

always @(*) begin   // to use assign or always is just a matter of habit, as it's not going to have any effect on your circuit
bin= ~|block_count[2:1] ? 1'b0: (buffer[64]>= threshold);
/* |block_count[2:1]  judge _ _ _ 0?0? x  and then not~
and bin's value has to be changed instantly, or it will wait another cycle in the always@(posedge clk) block */ 
end


always @(posedge reset or posedge clk) begin
if (reset) begin
    max<= 'b0;
	min<= 'hff;
	for(i=0; i<=64; i= i+1)
		buffer[i]<= 'b0;
	count<= 'b0; 
	block_count<= 'b0;
	tmp<= 'b0;
	threshold<= 'b0;
end
else begin
	// buffer
	buffer[0]<= pix_data;
	for(i=1; i<=64; i= i+1)
		buffer[i]<= buffer[i-1];

	// min, max, count
	if(count[6]) begin
		count<= 1;
		max<= pix_data;
		min<= pix_data;
	end
	else begin
		count<= count+ 1;
		if(pix_data> max)
			max<= pix_data;
		if(pix_data< min)
			min<= pix_data;
	end
	
	tmp= {1'b0, max}+ {1'b0, min};

	if(count[6]) begin
		// block_count
		if (block_count[2] & block_count[0]) // faster than block_count== 5'd5, because the later one has to create 5 bits comparators 
			block_count <= 5'b0;
		else 
			block_count<= block_count+ 1;
			
		// threshold
		if ((block_count[1]==0) & ~(block_count[0] ^ block_count[2])) // equals to if ((block_count== 0) | (block_count== 5))
			threshold<= 5'b0;
		else
			threshold= tmp[8:1]+ {7'b0, tmp[0]};
	end
end
end
endmodule

/*	count= count+ 1;
	buffer[count]= pix_data;
	
	this method will create massive multiplexer. 
	not only will enlarge the area, but also lead to delays
	hence, use loops ;)     */