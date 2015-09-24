% fun {AlphaSub X Bound}

   %   X
      
      %[lambda(X lambda(
      
      %case Expr of [lambda(X E) M] then %is a redex
	  
%	 case E of lambda(Y E2) then
%	    case M of [H T] then
%	       
%	       [lambda(X E) M]
%	    end
%	 end
 %     end
      
      %case Expr of lambda(Bound [Bound Z]) then
%	 lambda(z [z Z])
 %     end
 %  end	    

   fun {AlphaRename Expr}
      
      case Expr of [lambda(X E) M] then %is a redex
       	 case E of lambda(Y E2) then
	   
       	    %case E2 of [H T] then
       	       %if {IsFree Y T} then
       	       %end
       	    %end
       	    case M of [H T] then
	       %{IsFree E2 Y}
	       Expr
       	       %if {IsFree E2 H} then
       		%  {AlphaSub E2 H}
       		  %[lambda(X lambda(Y 
       	       %end
       		 % {AlphaSub X Y E2 H T}
       	       %else {AlphaSub X Y E2 T H} end
       	    end
       	 end
      else
	 Expr
      end
   end
