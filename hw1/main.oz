% James Adler AND SPEN-THUR!!!!
% Programming Languages - Assigment 1
% Professor Varela

% Exps = [
% 	   [lambda(x lambda(y [y x])) [y w]]
% 	   [lambda(x lambda(y [x y])) [y w]]
% 	   [lambda(x x) y]
% 	   lambda(x [y x])
% 	   [[lambda(y lambda(x [y x])) lambda(x [x x])] y]
% 	   [[[lambda(b lambda(t lambda(e [[b t] e]))) lambda(x lambda(y x))] x] y]
% 	   lambda(x [[lambda(x [y x]) lambda(x [z x])] x])
% 	   [lambda(y [lambda(x lambda(y [x y])) y]) [y w]]
% 	  ]

local
   Exps = [
	   [lambda(x lambda(y [y x])) [y w]]
	  ]
   Tmp
   Zz = "z"
   
   proc {RunAll ListOfExpressions}
      if ListOfExpressions == nil then skip
      else
	 {Browse {Run ListOfExpressions.1}}
	 {RunAll ListOfExpressions.2}
      end
   end

   %fun {BetaReduce E}
    %  E
   %end

   % declare ARename = fun {$ E X M}
% 		     case E of lambda(X SubE) then
% 			case SubE of lambda(Y SubE2) then
% 			   case M of H|T then %if M is a list - check if each free variable matches Y
% 			      {ARename Y SubE H}|{ARename Y SubE T}
% 			   else %M is not a list
% 			      {ARename Y SubE M}
% 			   end
% 			else
% 			   nil
% 			end
% 		     else
% 			if E == M then
% 			   z
% 			else
% 			   E
% 			end
% 		     end
% 		  end

   fun {AlphaSub Exp V}
      %case Exp of [H T] then
	 %[{BRSub H X M} {BRSub T X M}] %fix
      %[] lambda(V Sub) then
	 %lambda(V {BRSub Sub X M})
      %else
	 %if E == X then M else E end
      %end

      %case Exp of lambda(X Y) then
%	 case Y of [H T] then
%	   Y
%	 end
 %     end
      case Exp of lambda(X [X Z]) then
	 lambda(z [z Z])
	 
      end
      
   end	    

   fun {AlphaRename Exp}
     % {Browse Exp}
      % [lambda(x lambda(y [y x])) [y w]]
      % X = x
      % E = lambda(y [y x]))
      % M = [y w]
      case Exp of [lambda(X E) M] then
	% E
	 case E of lambda(Y E2) then
	    case M of [H T] then
	       %Tmp = [lambda(X E) M]
	       %Tmp
	       {AlphaSub E H}|{AlphaSub E T}

	    end
	    
	 end
      end   
   end

   fun {AlphaRename2 E}
      case E of [lambda(X Expr) M] then
	 
	 case Expr of lambda(Y Expr2) then
	     case M of [H T] then %free var is a list
	        E
	 %    else %singular free var
	 %       if M == Y then
	 % 	  Y
	 %       else
	 % 	  E
	 %       end
	     end
	 else
	    E
	 end
      end
   end
   
   
   fun {Run Exp}
      %{Browse Exp}
      {AlphaRename Exp}
      %{Browse {BetaReduce Exp.1}}
   end
in
   {RunAll Exps}
end


declare
fun {EtaR Exp}

case Exp of lambda ( X (E X) ) then
  if (X IS FREE IN E)
  	E
  end
end



end

