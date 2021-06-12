`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 21:04:29
// Design Name: 
// Module Name: rca
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


module rca(
input logic Cin, [3:0] A, [3:0] B,
    output logic Cout, [3:0] S
    );//4位行波进位加法器
    logic [2:0] cout;
    fulladder level0( .A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(cout[0]) );
    fulladder level1( .A(A[1]), .B(B[1]), .Cin(cout[0]), .S(S[1]), .Cout(cout[1]) );
    fulladder level2( .A(A[2]), .B(B[2]), .Cin(cout[1]), .S(S[2]), .Cout(cout[2]) );
    fulladder level3( .A(A[3]), .B(B[3]), .Cin(cout[2]), .S(S[3]), .Cout(Cout) );
endmodule
