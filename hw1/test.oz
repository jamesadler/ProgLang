local Parser
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
   [Parser] = {Module.link ['E:\Dropbox\_RPI\4SeniorYear\Fall2015\CSCI4430-ProgLang\Assig1-Oz\parser.ozf']}
   {RunAll {Parser.getExpsFromFile 'E:\Dropbox\_RPI\4SeniorYear\Fall2015\CSCI4430-ProgLang\Assig1-Oz\input.lambda'}}
end
