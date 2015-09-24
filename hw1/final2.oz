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

   fun {IsFree Expr V}
      % case Expr of lambda(X E) then
      % 	 if X == V then false
      % 	 else
      % 	    {IsFree E V}
      % 	 end
      % [] [H T] then
      % 	 {And {IsFree H V} {IsFree T V}}
      % else
      % 	 false
      % end
      
      
       case Expr of [H T] then
       	  {Or {IsFree H V} {IsFree T V}}
       else
       	  if Expr == V then true
       	  else false end
       end
   end


   fun {EtaReduce Expr}
      case Expr of lambda(A [E A]) then
	 if {IsFree E A} then Expr %checks if A is free in E
	 else {EtaReduce E} end
      [] [H T] then
	 [{EtaReduce H} {EtaReduce T}]
      else Expr
      end
   end

   fun {BetaSub E X M}
      case E of [H T] then
       	 [{BetaSub H X M} {BetaSub T X M}]
      [] lambda(V Sub) then
       	 lambda(V {BetaSub Sub X M})
      else
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

      % 	 if T == B then
      % 	    [H z]
      % 	 end
      end
      
   end

   
   fun {AlphaRename Expr}
      
      case Expr of [lambda(X E) M] then %is a redex	 
      	 case E of lambda(Y E2) then
	    case M of [H T] then
	       M
	       % if {IsFree Y H} then
	       % 	  Y = n
	       % end

	       % if {IsFree Y T} then
	       % 	  Y = n
	       % end

	       %[lambda(X lambda(Y E2) M]
      	       %if {IsFree E2 H} then
		  
      % 		  %E2.1
      % 		  %[lambda(X lambda(
      % 		  {AlphaSub E2 H}
      % 	       end
	       
      % 	       %{IsFree E2 T}
      % % 	       %{IsFree E2 Y}
      % % 	       Expr
      % %  	       %if {IsFree E2 H} then
      % %  		%  {AlphaSub E2 H}
      % %  		  %[lambda(X lambda(Y 
      % %  	       %end
      % %  		 % {AlphaSub X Y E2 H T}
      % %  	       %else {AlphaSub X Y E2 T H} end
      	    end      
      	 end
      else
       	 Expr
      end
   end

  %  fun {BoundVars Expr}
%       case Expr of [H T] then
% 	 {BoundVars H} | {BoundVars T}
%       [] lambda(X E) then
% 	 X | {BoundVars E}
%       end
%    end

%    fun {ToRename Expr}
%       %local L
% %	 L = {BoundVars 
%    end
   
   fun {AlphaRename2 Expr}
      Expr
      % case Expr of [lambda(X E) M] then
      % 	    case E of lambda(Y E2) then
      % 	       case M of [H T] then %free var is a list
      % 		  X | E | M
      % 	       end
      % 	    end      
      % else
      % 	 Expr
      % end
      
   end
   
   
   fun {Run Expr}
     {EtaReduce {BetaReduce {AlphaRename2 Expr}}}
      %{EtaReduce {BetaReduce Expr}}
   end
in
   {Browse "New Line"}
   {RunAll Exps}
end

