`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2024 12:21:09 PM
// Design Name: 
// Module Name: pma_reset_handler
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
module pma_reset_handler (
    input clk,
    input rst, 
    input reset_done,
    input [15:0] status_vector,
    output reg pma_reset
);

reg [23:0] counter;
reg [4:0] pma_reset_vec;

always @(posedge clk ) begin
    if (rst) begin
        counter <= 24'b0;
        pma_reset_vec <= 5'b0;
        pma_reset <= 1'b0;
    end
    else begin
        counter <= counter + reset_done;   // Count to increment from reset done= '1' till status_vector[1]= '1'
        pma_reset <= pma_reset_vec[4];    // Extending the reset for multicycles
        
        if ((counter == 156250) || (reset_done && status_vector[1])) begin // 156.25MHz * 10ms = 156250

            counter <= 24'b0;
            
            if (counter == 156250)  begin    // Only want to generate reset if the counter overflows
                pma_reset_vec <= 5'h1F;       // Reset pulse will be 5 clk cycles wide
            end
            else begin                                     // Good condition. Reset is done as well as link is good
                pma_reset_vec <= { pma_reset_vec[3:0],1'b0};
            end
        end 
        else begin                                 // Default condition.
            pma_reset_vec <= { pma_reset_vec[3:0],1'b0}; 
        end
    end
end

endmodule