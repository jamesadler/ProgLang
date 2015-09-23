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
   
   fun {Run Exp}
      %replace this place holder with your reducer
      Exp
   end
in
   {RunAll Exps}
end
