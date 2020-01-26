module keyboard(
input wire clk,
input wire PS2Clk, // Clock pin form keyboard
input wire data, //Data pin form keyboard
output reg [7:0]reg_out, //ascii of number pressed
output wire flag_1
);
reg [7:0] data_next; // holding current pressed button's data stream coming from keyboard
reg [7:0] data_prev; // holding previous pressed button's data stream 
reg [3:0] b; // single bit coming from data pin of keyboard at the neg edge of keyboard clock
reg flag;// marks the ending bit of bitstream of button pressed
assign flag_1 = (b == 11)?1:0;
initial
    begin
        b<=4'h1;
        flag<=1'b0;
        data_next<=8'hf0;
        data_prev<=8'hf0;
        reg_out<=8'hff;
    end
    
always @(negedge PS2Clk) //Activating at negative edge of clock from keyboard
    begin
        case(b)
            1:; //first bit
            2:data_next[0]<=data;
            3:data_next[1]<=data;
            4:data_next[2]<=data;
            5:data_next[3]<=data;
            6:data_next[4]<=data;
            7:data_next[5]<=data;
            8:data_next[6]<=data;
            9:data_next[7]<=data;
            10:flag<=1'b1; //Parity bit
            11: begin 
                flag<=1'b0; //Ending bit
                end
        endcase
    end
 //incrementing counter for bits
 always @(negedge PS2Clk)
    begin   
        if(b<=10)
            b<=b+1;
        else if(b==11)
            b<=1; // reset counter to 1 when counter = 11
    end

// storing the scan code in 'reg_out' when button that was pressed is relaesed,
// and hence 8'hf0 is being sent on the data pin
always@(negedge PS2Clk) 
begin
    if(b == 10 && data_next==8'hf0)
        reg_out<=data_prev;
end

always@(negedge PS2Clk) 
begin
    if(b == 10 && data_next!=8'hf0)
        data_prev<=data_next;
end 

endmodule
