% James Adler and Spencer Norris
% Programming Languages - Assigment 1
% Professor Varela

local
   Exps = [	 
	   [lambda(x lambda(y [y x])) [y w]]
 	   [lambda(x lambda(y [x y])) [y w]]
 	   [lambda(x x) y]
 	   lambda(x [y x])
 	   [[lambda(y lambda(x [y x])) lambda(x [x x])] y]
 	   [[[lambda(b lambda(t lambda(e [[b t] e]))) lambda(x lambda(y x))] x] y]
 	   lambda(x [[lambda(x [y x]) lambda(x [z x])] x])
 	   [lambda(y [lambda(x lambda(y [x y])) y]) [y w]]
	  ]
   
   proc {RunAll ListOfExpressions}
      if ListOfExpressions == nil then skip
      else
	 {Browse {Run ListOfExpressions.1}}
	 {RunAll ListOfExpressions.2}
      end
   end

   % Checks if V is free or bounded
   fun {IsFree Expr V}      
      case Expr of lambda(X E) then
	 if X == V then false
	 else
	    {IsFree E V} % Checks if V is free in E
	 end
	[] [H T] then
       	  {And {IsFree H V} {IsFree T V}} % Checks if V is free in H and T
       else
	 if Expr == V then
	    true
	 else
	    false
	 end
       end
   end

   % Eta reduces Expr
   fun {EtaReduce Expr}
      case Expr of lambda(A [E A]) then
	 if {IsFree E A} then Expr % Checks if A is free in E
	 else {EtaReduce E} end % If it's not Eta reduce E
      [] [H T] then
	 [{EtaReduce H} {EtaReduce T}] % If the Expr is a touple, Eta reduce head and tail
      else
	 Expr
      end
   end

   fun {BetaSub E X M}
      case E of lambda(Y E2) then E3 in
	 E3 = {BetaSub E2 X M}
       	 lambda(Y E3)
      []  [H T] then
	 [{BetaSub H X M} {BetaSub T X M}]  % If the E is a touple, Beta reduce head and tail
      else
	 % If E is a single var
       	 if E == X then
       	    M
       	 else
       	    E
       	 end
      end
   end
   
   fun {BetaReduce Expr}
      case Expr of [lambda(X E) M] then
	 {BetaReduce {BetaSub E X M}}
      [] [H T] then
	 % If the head and tail Beta reduce then Beta reduce the reduced head and tail
       	 case [{BetaReduce H} {BetaReduce T}] of [lambda(X E) M] then
       	    {BetaReduce [{BetaReduce H} {BetaReduce T}]}
       	 else
       	    [{BetaReduce H} {BetaReduce T}]
       	 end
      else
      	 Expr
      end
   end

   fun {AlphaSub Expr B}
      
      case Expr of [H T] then
       	 if H == B then
	    [z T]
	 end
	 
	 % [] T == B then
	 %    [H z]
	 % else
	 %    [H T]
       	 % end

      end
   end

   
   fun {AlphaRename Expr}
      
      % case Expr of [lambda(X E) M] then %is a redex	 
      % 	 case E of lambda(Y E2) then
      % 	    case M of [H T] then
      % 	       Expr
      % 	       % if {IsFree Y H} then
      % 	       % 	  Y = n
      % 	       % end

      % 	       % if {IsFree Y T} then
      % 	       % 	  Y = n
      % 	       % end

      % 	       %[lambda(X lambda(Y E2) M]
      % 	       %if {IsFree E2 H} then
		  
      % % 		  %E2.1
      % % 		  %[lambda(X lambda(
      % % 		  {AlphaSub E2 H}
      % % 	       end
	       
      % % 	       %{IsFree E2 T}
      % % % 	       %{IsFree E2 Y}
      % % % 	       Expr
      % % %  	       %if {IsFree E2 H} then
      % % %  		%  {AlphaSub E2 H}
      % % %  		  %[lambda(X lambda(Y 
      % % %  	       %end
      % % %  		 % {AlphaSub X Y E2 H T}
      % % %  	       %else {AlphaSub X Y E2 T H} end
      % 	    end      
      % 	 end
      % else
      %  	 Expr
      % end
      Expr
   end  
   
   fun {Run Expr}
     {EtaReduce {BetaReduce {AlphaRename Expr}}}
   end
in
   {RunAll Exps}
end

