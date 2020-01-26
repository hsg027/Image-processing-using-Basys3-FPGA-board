module vga_display

	(
		input wire clk, //100MHz clock
		input btnC,		//reset
		output wire hsync, vsync, 
		output wire display, //signal to indicate pixel within valid display area
		output wire clk_25_hi,
		output wire [9:0] h_out, v_out // horizontal and vertical pixel position
	);
	
	// clock divider to reduce clock frequency to 25 MHz clock from 100 MHz FPGA clock	
	reg [1:0] clk100_out; 
	wire [1:0] clk100_in;
	wire clk_25;	
	
	always @(posedge clk, posedge btnC)
		if(btnC)
		clk100_out <= 0;
		else
		  clk100_out <= clk100_in;
	
	assign clk100_in = clk100_out + 1; // increment counter
	
	assign clk_25 = (clk100_out == 0); // To ensure clk_25 is only HIGH for 1 clock 
					//cycle of 100 MHz clock, at the clock rising edge
	
	// current pixel location - hrzntl_cs, vrtcl_cs
	//next pixel location - hrzntl_ns, vrtcl_ns
	reg [9:0] hrzntl_cs, hrzntl_ns, vrtcl_cs, vrtcl_ns;

	// At each 25 MHz clock, keep incrementing horizontal pixel count until	
	//end of one horizontal line is completed on screen	
	always @*	
		begin
		  hrzntl_ns = clk_25 ? 								 
		               hrzntl_cs == 799 ? 0 : hrzntl_cs + 1 
			       : hrzntl_cs;
		end
		
	// updating horizontal pixel count	
	always @(posedge clk, posedge btnC)
         if(btnC)
                hrzntl_cs <= 0;
         else
                hrzntl_cs <= hrzntl_ns;
                    
	
	// updating vertical pixel count	
	always @(posedge clk, posedge btnC)
		if(btnC)
               vrtcl_cs <= 0;
		else
               vrtcl_cs <= vrtcl_ns;	

	// At each 25 MHz clock, if horizontal pixel count reached maximum 799, 
	//then keep incrementing vertical pixel count until maximum vertical pixel count is reached
	always @*
        begin
            vrtcl_ns = clk_25 && hrzntl_cs == 799 ? 			
                           (vrtcl_cs == 524 ? 0 : vrtcl_cs + 1) 
                       : vrtcl_cs;
        end	

    // 'display' HIGH indicates current pixel is within 640x480 display region
    assign display = (hrzntl_cs < 640) 
                          && (vrtcl_cs < 480);
						  
	// register to store current state and next state of hsync and vsync signals
	reg vsync_cs, hsync_cs;
	wire vsync_ns, hsync_ns;
	
	always @(posedge clk, posedge btnC)
		   if(btnC)
                hsync_cs   <= 0;
           else
                hsync_cs   <= hsync_ns;
		
    assign hsync_ns = hrzntl_cs >= 656	// hsync HIGH during horizontal retrace width
                            && hrzntl_cs <= 751;
							
	always @(posedge clk, posedge btnC)
          if(btnC)
                vsync_cs   <= 0;
          else
                vsync_cs   <= vsync_ns;

    assign vsync_ns = vrtcl_cs >= 490 	// vsync HIGH during vertical retrace width
                            && vrtcl_cs <= 491;

    assign hsync  = hsync_cs;  //output
    assign vsync  = vsync_cs;  //output
    assign h_out  = hrzntl_cs;  //output
    assign v_out  = vrtcl_cs;  //output
    assign clk_25_hi = clk_25;  //output
	
endmodule
