`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.02.2019 00:41:16
// Design Name: 
// Module Name: buffer_tb
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


module buffer_tb();
reg  clock,reset,push,pull;
reg [7:0]  tail;
wire [7:0] head;
wire [2:0]counter;

buffer bu (.clock(clock),.reset(reset),.push(push),.pull(pull),.tail(tail),.head(head),.counter(counter));

initial begin
    clock=1'b0;
  // Initialize Inputs
    reset=1'b1;
    push=0;
    pull=0;
    tail=0;
    #20;
    reset=1'b0;
    tail=1;
    push=1;
    #20
    reset=0;
    #20
    tail=2;
    #20
    tail=3;
    #20
    tail=4;
    #20
    tail=5;
    #20
    tail=6;
    #20
    tail=7;
    #20
    tail=8;
    #20
    tail=9;
    #20
    //push=0;
    //#20
    pull=1;
    #20
    push=0;//apagar depois 
    #40;
    pull=0;
    push=1;
    #60
    $finish;
 end 

   always #5 clock = ~clock;    


endmodule
