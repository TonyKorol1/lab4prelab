module divisible_by_5 (
input logic clk,
input logic rst_n,
input logic serial_i,
output logic divisible_by_5_o
);
typedef enum logic [2:0] {
REMAINDER_0, //divisible
REMAINDER_1, //not divisible (1011)
REMAINDER_2, //not divisible (10111)
REMAINDER_3, //not divisible (101111)
REMAINDER_4  //not divisible
} state_t;
state_t state_d, state_q = REMAINDER_0;
assign divisible_by_5_o = (state_q == REMAINDER_0);
always_comb begin
state_d = REMAINDER_0;
if (serial_i) begin
case (state_q) // 2*num + 1
REMAINDER_0: state_d = REMAINDER_1; //first iteration (11 if start from 5)
REMAINDER_1: state_d = REMAINDER_2; //2nd (23)
REMAINDER_2: state_d = REMAINDER_3; //3rd (47)
REMAINDER_3: state_d = REMAINDER_0; //at this point it rolls over (95 if starting with 101)
REMAINDER_4: state_d = REMAINDER_4; //no way to make divisible with 1

endcase
end else begin
case (state_q) // 2*num + 0
REMAINDER_0: state_d = REMAINDER_0; //still divisible (x2)
REMAINDER_1: state_d = REMAINDER_3; //puts in 3rd iteration of 1's case
REMAINDER_2: state_d = REMAINDER_1; //etc
REMAINDER_3: state_d = REMAINDER_4; //extra state which needs another 0 to continue
REMAINDER_4: state_d = REMAINDER_2; //returns to sequence with another 0
endcase
end
end
always_ff @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
state_q <= REMAINDER_0;
end else begin
state_q <= state_d;
end
end
endmodule
