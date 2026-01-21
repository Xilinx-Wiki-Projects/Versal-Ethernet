`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2023 03:56:36 PM
// Design Name: 
// Module Name: rxcommaalignen_out_shifter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rxcommaalignen_out_shifter #(
  parameter CHANNEL_ID = 2
)
(
    input wire rxcommaalignen_in_ch2,
    input wire rxcommaalignen_in_ch3,
    output wire [15:0] gpi_out
);

// ORIGINAL assign gpi_out = {5'b0,rxcommaalignen_in,10'b0};
reg [15:0] gpi_out_reg;
// Now connecting signal to GPIO[6]
//assign gpi_out = {9'b0,rxcommaalignen_in,6'b0};

assign gpi_out = gpi_out_reg;

always@* begin
  gpi_out_reg                 = 16'b0;
  gpi_out_reg[CHANNEL_ID + 8] = rxcommaalignen_in_ch2;
  gpi_out_reg[CHANNEL_ID + 1 + 8] = rxcommaalignen_in_ch3;

end

endmodule



