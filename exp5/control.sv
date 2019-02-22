module control
(
    input   logic Clk, Reset, LoadB_ClearA, Run, M,
    output  logic Shift_En, Clr_Ld, Add, Sub, Reset_out, Clr_cont
);

	enum logic [4:0] {start,A,B,C,D,E,F,G,H,A2,B2,C2,D2,E2,F2,G2,H2,hold,reset_state,mid,Sign,cont} curr_state, next_state;
	always_ff @ (posedge Clk or posedge Reset) 
	begin
		if (Reset)
			curr_state <= reset_state;
		else 
			curr_state <= next_state;
	end
	
	always_comb

	begin
	
		
		next_state = curr_state;
		unique case (curr_state)
//			load: if (LoadB_ClearA)
//				next_state = start;
			reset_state: next_state = start;
			start: if(~Run)
				next_state = Sign;
			cont: next_state = A ;
			Sign: next_state = A ;
			A : next_state = A2;
			A2: next_state = B ;
			B : next_state = B2;
			B2: next_state = C ;
			C : next_state = C2;
			C2: next_state = D ;
			D : next_state = D2;
			D2: next_state = E ;
			E : next_state = E2;
			E2: next_state = F ;
			F : next_state = F2;
			F2: next_state = G ;
			G : next_state = G2;
			G2: next_state = H ;
			H : next_state = H2;
			H2: next_state = mid;
			mid: if (Run)
						next_state = hold;
			hold: if(Reset) 
						next_state = reset_state;
					else if(~Run)
						next_state = cont;//continue state
		endcase
	
		case (curr_state)
			reset_state:
			begin
				Reset_out <= 1'b1;
				Shift_En <= 1'b0;
				Add <=1'b0;
				Sub <=1'b0;
				Clr_cont <= 1'b0;
				Clr_Ld <= 1'b0;
			end
			cont:
			begin
				Reset_out <= 1'b0;
				Shift_En <= 1'b0;
				Add <=1'b0;
				Sub <=1'b0;
				Clr_Ld <= 1'b0;
				Clr_cont <=1'b1;
			end
			start:
			begin
				Reset_out <= 1'b0;
				Shift_En <= 1'b0;
				Add <=1'b0;
				Sub <=1'b0;
				Clr_cont <= 1'b0;
				if (~LoadB_ClearA)
					Clr_Ld <= 1'b1;
				else
					Clr_Ld <= 1'b0;

			end
			Sign://due to previous design, not necessary for this version
			begin
				Reset_out <= 1'b0;
				Shift_En <= 1'b0;
				Add <=1'b0;
				Sub <=1'b0;
				Clr_cont <= 1'b0;
				Clr_Ld <= 1'b0;
			end
			A,B,C,D,E,F,G://ADD
			begin
				Reset_out <= 1'b0;
				Shift_En <= 1'b0;
				Clr_Ld <= 1'b0;
				Sub <=1'b0;
				Clr_cont <= 1'b0;
				if (M) 
					Add <=1'b1;
				else
					Add <=1'b0;
			end
			A2,B2,C2,D2,E2,F2,G2,H2://SHIFT
			begin
				Reset_out <= 1'b0;
				Shift_En <= 1'b1;
				Clr_Ld <= 1'b0;
				Sub <=1'b0;
				Add <=1'b0;
				Clr_cont <= 1'b0;
			end
			H:
			begin
				Reset_out <= 1'b0;
				Shift_En <= 1'b0;
				Clr_Ld <= 1'b0;
				Clr_cont <= 1'b0;
				Add <=1'b0;
				if (M)
					Sub <=1'b1;
				else
					Sub <=1'b0;
			end
//			load:
//			begin
//				if (LoadB_ClearA)
//					Reset_out <= 1'b0;
//					Shift_En <= 1'b0;
//					Clr_Ld <= 1'b1;
//					Sub <=1'b0;
//					Add <=1'b0;
//			end
			hold:
			begin				
				Reset_out <= 1'b0;
				Shift_En <= 1'b0;
				Clr_Ld <= 1'b0;
				Clr_cont <= 1'b0;
				Add <=1'b0;
				Sub <=1'b0;
			end
			mid:
			begin
				Reset_out <= 1'b0;
				Shift_En <= 1'b0;
				Clr_Ld <= 1'b0;
				Clr_cont <= 1'b0;
				Add <=1'b0;
				Sub <=1'b0;
			end
			default:
			begin
				Reset_out <= 1'b0;
				Shift_En <= 1'b0;
				Clr_Ld <= 1'b0;
				Add <=1'b0;
				Clr_cont <= 1'b0;
				Sub <=1'b0;
			end
		endcase
	end
endmodule
	