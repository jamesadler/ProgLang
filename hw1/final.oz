% James Adler and Spencer Norris
% Programming Languages - Assigment 1
% Professor Varela

 %[lambda(x lambda(y [x y])) [y w]]
 	   %[lambda(x x) y]
 	   %lambda(x [y x])
 	   %[[lambda(y lambda(x [y x])) lambda(x [x x])] y]
 	   %[[[lambda(b lambda(t lambda(e [[b t] e]))) lambda(x lambda(y x))] x] y]
 	   %lambda(x [[lambda(x [y x]) lambda(x [z x])] x])
 	   %[lambda(y [lambda(x lambda(y [x y])) y]) [y w]]

local
   Exps = [	 
	   [lambda(x lambda(y [y x])) [y w]]
	  ]
   
   proc {RunAll ListOfExpressions}
      if ListOfExpressions == nil then skip
      else
	 {Browse {Run ListOfExpressions.1}}
	 {RunAll ListOfExpressions.2}
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
   
  
   fun {Run Expr}
     %{EtaReduce {BetaReduce {AlphaRename Expr}}}
      {BetaReduce Expr}
   end
in
   {Browse "New Line"}
   {RunAll Exps}
end

