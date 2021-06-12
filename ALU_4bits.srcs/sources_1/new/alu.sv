`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 21:06:06
// Design Name: 
// Module Name: alu
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


module alu(
    input [3 : 0] A,
input [3 : 0] B,
input [3 : 0] aluop,
output logic [7 : 0] alures,
output logic ZF,
output logic OF
);//算术逻辑单元ALU

/* 加法 */
logic add_OverFlow;
logic [3:0] add_outcome;
rca add( .Cin(1'b0), .A(A[3:0]), .B(B[3:0]), .Cout(add_OverFlow), .S(add_outcome) );

/* 减法 */
logic [3:0] minus_outcome, minusB;//存储-B
logic minus_OF;
assign minusB = ~B + 1;//把B变成-B
rca minus( .Cin(1'b0), .A(A[3:0]), .B(minusB), .Cout(minus_OF), .S(minus_outcome) );

always_comb begin
    case(aluop)
        4'b0000:begin//按位与
                alures[7:4] = 4'b0000;
                alures[3:0] = A & B;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0001:begin//按位或
                alures[7:4] = 4'b0000;
                alures[3:0] = A | B;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0010:begin//按位异或
                alures[7:4] = 4'b0000;
                alures[3:0] = A ^ B;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0011:begin//按位与非
                alures[7:4] = 4'b0000;
                alures[3:0] = ~(A & B);
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0100:begin//逻辑非
                alures[7:4] = 4'b0000;
                alures[3:0] = ~A;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0101:begin//逻辑左移
                alures[7:4] = 4'b0000;
                alures[3:0] = A << B[2:0];
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0110:begin//逻辑右移
                alures[7:4] = 4'b0000;
                alures[3:0] = A >> B[2:0];
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0111:begin//算术右移
                int temp, i;
                alures[7:4] = 4'b0000;
                temp = A[3];
                alures[3:0] = A >>> B[2:0];
                for( i = 0; i < B[2:0]; i++ )
                    alures[3-i] = temp;//补B[2:0]个符号位
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1000:begin//无符号数乘法
                alures = A * B;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1001:begin//有符号数乘法
                logic temp;
                logic [2:0] A_t, B_t;
                temp = A[3] ^ B[3];//取最终的正负号
                A_t = A[2:0];
                B_t = B[2:0];
                if( A[3] == 1 )
                    A_t = ( ~A[2:0] ) + 1;//补码转换成原码
                if( B[3] == 1 )
                    B_t = ( ~B[2:0] ) + 1;//补码转换成原码
                alures[6:0] = ( A_t ) * ( B_t );//相乘
                if( temp == 1 )//如果结果是负数，就取补码
                    alures[6:0] = ( ~alures[6:0] ) + 1;//负数结果从原码变补码
                alures[7] = temp;//符号位
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1010:begin//有符号数加法
                alures[7:4] = 4'b0000;
                //OF = add_OverFlow;
                alures[3:0] = add_outcome;
                if( (A[3] ^ B[3]) == 0 && alures[3] != A[3] )
                    OF = 1;//同号且相加结果的符号位变了，说明溢出
                else
                    OF = 0;
                ZF = (alures == 0) ? 1:0;
        end
        4'b1011:begin//无符号数加法
                alures[7:4] = 4'b0000;
                alures[3:0] = add_outcome;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1100:begin//有符号数减法
                alures[7:4] = 4'b0000;
                //OF = minus_OF;
                alures[3:0] = minus_outcome;
                if( (A[3] ^ B[3]) == 1 && alures[3] != A[3] )
                    OF = 1;//异号且相减且结果的符号位与被减数不同，说明溢出
                else
                    OF = 0;
                ZF = (alures == 0) ? 1:0;
        end
        4'b1101:begin//无符号数减法
                alures[7:4] = 4'b0000;
                alures[3:0] = minus_outcome;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1110:begin//有符号数比较
                logic sign;
                alures[7:4] = 4'b0000;
                sign = A[3] ^ B[3];
                //异号
                if( sign == 1 )
                    alures[3:0] = (B[3] == 0)?1:0;//异号且B为正为1
                else//同号
                    alures[3:0] = ( minus_outcome[3] == 1 )?1:0;//同号且B大为1
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1111:begin//无符号数比较
                alures[7:4] = 4'b0000;
                alures[3:0] = (minus_outcome[3] == 1)?1:0;//B大为1
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        default:;
    endcase
end
endmodule
