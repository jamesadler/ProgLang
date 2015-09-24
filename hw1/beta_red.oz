declare
fun {Eval Exp}
	% Application Evalulation
	case Exp of [L, M] then
		case L of lambda (X E) then	 	% Beta Reduction Check
			BetaRed [ Eval L, Eval M ]
		else Eval [ Eval L, Eval M ]
		end
	end

	% Anonymous Function Evaluation
	case Exp of lambda (X E) then
		case E of [R, X] then					 % Eta Conversion Check
				Eval R
		else
				Eval E
		end
	end

	% Single Var Evaluation
	case Exp of [X] then Exp end
end




declare
fun {BetaRed Exp}
	case Exp of [L M] then

		%HANDLE L
		case L of lambda (X E) then
			case E of [S1, S2] then
			BetaRed E
			Sub E X M

			else case E of [x] then
				EtaConv Exp

			end


		else case L of [S1, S2] then
			BetaRed L
		end

		%HANDLE M
	end

	else case Exp of [] then [] end
end

declare
fun {EtaConv Exp}

end



declare
fun {IsBound Var Exp}
	case Exp in [] then false end %Blank statement Check

	case Exp in [L M] then

		case L in lambda (X E) then

			case Exp in X then true
			else false
			end

		end

	end
end





PATTERN:
BIG FUNCTION

	RECURSE DOWN THE TUPLE TREE

		GET TO BOTTOM OF TREE
		IS 2ND IN TUPLE BOUND IN 1ST IN TUPLE? ----> HANDLE WITH A RECURSIVE FUNCTION THAT GOES DOWN TUPLE TREE
			IF YES, THEN ALPHA RENAME 1ST (CHANGE NAMES OF VARIABLES INSIDE FUNCTION)
		BETA REDUCE
		SET 1ST IN NEXT TUPLE UP TO NEW STATEMENT

	REPEAT ON THE NEXT STATEMENT AT THE BOTTOM OF THE TREE (WILL BE LEFTMOST)

END OF BIG FUNCTION
