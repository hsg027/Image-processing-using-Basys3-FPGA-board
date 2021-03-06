module TB();
    reg clk;
    reg PS2Clk;
    reg data;
    reg btnC;
    wire hsync;
    wire vsync;
    wire [11:0] out;

 top DUT(
    .clk(clk),             // board clock: 100 MHz on Arty/Basys3/Nexys
    .btnC(btnC), // reset button
    .PS2Clk(PS2Clk), //keyboard clock 
    .data(data), //Data pin form keyboard
    .hsync(hsync),       // horizontal sync output
    .vsync(vsync),       // vertical sync output
    .out(out) //12-bit signal output to VGA connector. 4-bit each for Red, Green & blue
    );
    
    
initial
begin
#0 clk=0;
#0 PS2Clk=1;
#0 data=1;
#0 btnC=1;
#100 btnC=0;
#500 data=0;//Start bit
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=1;//bit 0
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//bit 1
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=1;//bit 2
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//bit 3
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//bit 4
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//bit 5
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=1;//bit 6
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//bit 7
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//parity

#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=1;//stop
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//Start bit
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//bit 0
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//bit 1
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//bit 2
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=0;//bit 3
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=1;//bit 4
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=1;//bit 5
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=1;//bit 6
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=1;//bit 7
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=1;//parity
#500 PS2Clk=0;
#1000 PS2Clk=1;
#500 data=1;//stop
#500 PS2Clk=0;
#1000 PS2Clk=1;
end

always #5 clk=~clk;
    
endmodule
