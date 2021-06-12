`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 21:02:32
// Design Name: 
// Module Name: fulladder
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


module fulladder(
input logic A, B, Cin,
    output logic S, Cout
    );//È«¼ÓÆ÷
    logic [1:0] temp;
    assign temp = A + B + Cin;
    assign S = temp[0];
    assign Cout = temp[1];
endmodule
