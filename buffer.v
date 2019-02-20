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
module buffer  #(parameter BUFFER_WIDTH=16,BUFFER_DEPTH=8)
(
input  clock,reset,push,pull,
input [BUFFER_WIDTH-1:1]  tail,
output reg [BUFFER_WIDTH-1:1] head,
output reg[BUFFER_WIDTH-1:1]counter
);

reg p;   
reg [BUFFER_WIDTH-1:1] buff [BUFFER_WIDTH-1:1];
reg is_full;
reg [BUFFER_WIDTH-1:0] first;
reg [BUFFER_WIDTH-1:0] last;
always@(*)  
    begin
    head=buff[first];
    counter= (is_full)? BUFFER_DEPTH:(last >= first)? last - first:BUFFER_DEPTH - (first - last);       
    end
    
reg [BUFFER_WIDTH-1:0] aux_first,aux_last;
reg aux_is_full,is_empty;
always@(posedge clock,reset)
    begin     
       if (reset)      
           begin
               last=0;
               first=0;
               is_full=0;
               is_empty=0;
           end
   
            if (clock && reset==0)
                begin
                    aux_is_full= is_full;
                    aux_last= last;
                    aux_first= first;
                    if (is_empty && pull==1)
                                 begin
                                    begin
                                        if (aux_first == BUFFER_DEPTH -1) 
                                             aux_first = 0;
                                        else
                                             aux_first= aux_first + 1;
                                    end   
                                   
                                 end
                    if (is_empty && push==1)
                                 begin
                                    begin
                                        if (aux_last == BUFFER_DEPTH -1) 
                                            aux_last = 0;
                                        else
                                            aux_last= aux_last + 1;
                                    end    
                                                
                                 end                       
           is_full= aux_is_full;
           last=aux_last;
           first=aux_first;  
           end 
             
       end   
     
 endmodule