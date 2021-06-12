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
);//�����߼���ԪALU

/* �ӷ� */
logic add_OverFlow;
logic [3:0] add_outcome;
rca add( .Cin(1'b0), .A(A[3:0]), .B(B[3:0]), .Cout(add_OverFlow), .S(add_outcome) );

/* ���� */
logic [3:0] minus_outcome, minusB;//�洢-B
logic minus_OF;
assign minusB = ~B + 1;//��B���-B
rca minus( .Cin(1'b0), .A(A[3:0]), .B(minusB), .Cout(minus_OF), .S(minus_outcome) );

always_comb begin
    case(aluop)
        4'b0000:begin//��λ��
                alures[7:4] = 4'b0000;
                alures[3:0] = A & B;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0001:begin//��λ��
                alures[7:4] = 4'b0000;
                alures[3:0] = A | B;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0010:begin//��λ���
                alures[7:4] = 4'b0000;
                alures[3:0] = A ^ B;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0011:begin//��λ���
                alures[7:4] = 4'b0000;
                alures[3:0] = ~(A & B);
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0100:begin//�߼���
                alures[7:4] = 4'b0000;
                alures[3:0] = ~A;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0101:begin//�߼�����
                alures[7:4] = 4'b0000;
                alures[3:0] = A << B[2:0];
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0110:begin//�߼�����
                alures[7:4] = 4'b0000;
                alures[3:0] = A >> B[2:0];
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b0111:begin//��������
                int temp, i;
                alures[7:4] = 4'b0000;
                temp = A[3];
                alures[3:0] = A >>> B[2:0];
                for( i = 0; i < B[2:0]; i++ )
                    alures[3-i] = temp;//��B[2:0]������λ
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1000:begin//�޷������˷�
                alures = A * B;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1001:begin//�з������˷�
                logic temp;
                logic [2:0] A_t, B_t;
                temp = A[3] ^ B[3];//ȡ���յ�������
                A_t = A[2:0];
                B_t = B[2:0];
                if( A[3] == 1 )
                    A_t = ( ~A[2:0] ) + 1;//����ת����ԭ��
                if( B[3] == 1 )
                    B_t = ( ~B[2:0] ) + 1;//����ת����ԭ��
                alures[6:0] = ( A_t ) * ( B_t );//���
                if( temp == 1 )//�������Ǹ�������ȡ����
                    alures[6:0] = ( ~alures[6:0] ) + 1;//���������ԭ��䲹��
                alures[7] = temp;//����λ
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1010:begin//�з������ӷ�
                alures[7:4] = 4'b0000;
                //OF = add_OverFlow;
                alures[3:0] = add_outcome;
                if( (A[3] ^ B[3]) == 0 && alures[3] != A[3] )
                    OF = 1;//ͬ������ӽ���ķ���λ���ˣ�˵�����
                else
                    OF = 0;
                ZF = (alures == 0) ? 1:0;
        end
        4'b1011:begin//�޷������ӷ�
                alures[7:4] = 4'b0000;
                alures[3:0] = add_outcome;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1100:begin//�з���������
                alures[7:4] = 4'b0000;
                //OF = minus_OF;
                alures[3:0] = minus_outcome;
                if( (A[3] ^ B[3]) == 1 && alures[3] != A[3] )
                    OF = 1;//���������ҽ���ķ���λ�뱻������ͬ��˵�����
                else
                    OF = 0;
                ZF = (alures == 0) ? 1:0;
        end
        4'b1101:begin//�޷���������
                alures[7:4] = 4'b0000;
                alures[3:0] = minus_outcome;
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1110:begin//�з������Ƚ�
                logic sign;
                alures[7:4] = 4'b0000;
                sign = A[3] ^ B[3];
                //���
                if( sign == 1 )
                    alures[3:0] = (B[3] == 0)?1:0;//�����BΪ��Ϊ1
                else//ͬ��
                    alures[3:0] = ( minus_outcome[3] == 1 )?1:0;//ͬ����B��Ϊ1
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        4'b1111:begin//�޷������Ƚ�
                alures[7:4] = 4'b0000;
                alures[3:0] = (minus_outcome[3] == 1)?1:0;//B��Ϊ1
                ZF = (alures == 0) ? 1:0;
                OF = 0;
        end
        default:;
    endcase
end
endmodule
