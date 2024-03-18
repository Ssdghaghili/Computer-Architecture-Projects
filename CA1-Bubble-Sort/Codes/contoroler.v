module ControllerUnit (input clk, rst ,start, ready, cop1, cop2, copratorsignal, output reg rstp, enp1, enp2, ldD1, ldD2, sp, sD, read, write, eninc, inzp2, encomp, done);
  parameter [3:0]
  Idle=0, Reset=1, Cnt1=2, Cnt2=3, Compare=4, Write1=5, Write2=6, Move=7, Done=8;
  reg [1:0] pstate, nstate;

  always @(pstate, start, ready, cop1, cop2, copratorsignal) begin
    nstate = Idle;
    {rstp, enp1, enp2, ldD1, ldD2, sp, sD, read, write, eninc, inzp2, encomp, done} = 13'b0000000000000;

    case (pstate)
        Idle    :begin nstate = start ? Reset : Idle; end
        Reset   :begin nstate = Cnt1; rstp = 1'b1; end    
        Cnt1    :begin nstate = cop1 ? Cnt2 : Done; {enp1,read,ldD1} = 3'b111; sD = 1'b0 ;sp = 1'b0; end
        Cnt2    :begin nstate = ready ? Compare : Cnt2; {enp2,read,inzp2,eninc,ldD2} = 5'b11111; sD = 1'b1 ;sp = 1'b1; end
	Compare :begin nstate = copratorsignal ? Write1 : Move; encomp = 1'b0; end
	Write1  :begin nstate = ready ? Write2 : Write1; write = 1'b1; sp = 1'b0; sD= 1'b1; end
	Write2  :begin nstate = ready ? Move : Write2; write = 1'b1; sp = 1'b1; sD= 1'b0; end
	Move	:begin nstate = cop2 ? Cnt1 : Compare; end
	Done	:begin nstate = Done; done = 1'b1;end
    endcase
  end

  always @(posedge clk or posedge rst) begin
    if (rst)
      pstate <= Idle;
    else
      pstate <= nstate;
  end
endmodule