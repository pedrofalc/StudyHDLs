//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UFC
// Engineer: Pedro Falcão
//
// Create Date: 18.02.2019 20:31:56
// Design Name:
// Module Name:
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
module fifo_buffer  #(parameter BUFFER_WIDTH=23), #(parameter BUFFER_DEPTH=23)
(
input  clock,reset,push,pull,
input [BUFFER_WIDTH-1:0]  tail,
output[BUFFER_WIDTH-1:0] head,
output [BUFFER_WIDTH-1:0]counter
)

function  myfunction;
inout p;
begin
   myfunction =
   if p = BUFFER_DEPTH - 1 then
       p = 0;
   else
       p = p + 1;
   end if;
end
 endfunction
