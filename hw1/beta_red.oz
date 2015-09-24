declare
fun {Eval Exp}
	% Application Evaluation
	case Exp of [L, M] then
		case L of lambda (X E) then	 	% Beta Reduction Check
			BetaRed [ Eval L, Eval M ]  % PROBLEM: WILL BETA REDUCE EVEN IF L GETS ETA-CONVERTED OUT
		else Eval [ Eval L, Eval M ]
		end
	end

	% Anonymous Function Evaluation
	case Exp of lambda (X E) then
		case E of [R, X] then					 % Eta Conversion Check (automatically handled)
				Eval R
		else if (IT DOESN'T LOOP ON ITSELF) % FIX FIX FIX
				Eval lambda (X Eval E)
		end
	end

	% Single Var Evaluation
	case Exp of [X] then Exp end
end


% BETA REDUCTION FUNCTIONS

declare
fun {BetaRed Exp}
	case Exp of [L M] then
		case L of lambda (X E) then
			BetaHelper E X M
		end
		else L | M
	end
end


% Subs in applied var M
declare
fun {BetaHelper Exp B M}

	% Single var
	case Exp of [X] then
		case [X] of B then
			[M]
		end
	end

	% Create new anonymous function
	case Exp of lambda (X E) then
		lambda (X BetaHelper E B M)
	end

	% Standard application; check for match
	case Exp of [H, T] then
		case H of B then
			M | BetaHelper Exp B M
		else
			H | BetaHelper Exp B M
		end
	end
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
