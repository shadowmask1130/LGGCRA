%_________________________________________________________________________%
%  Greater Cane Rat Algorithm (GCRA)                                       %
%                                                                         %
%  Developed in MATLAB R2020b                                             %
%                                                                         %
%  Designed and Developed: Dr. Ovre Agushaka                              %
%                                                                         %
%         E-Mail: jo.agushaka@science.edu.ng                              %
%                 jefshak@gmail.com                                       %
%                                                                         %
%                                  
%                                                                         %
%  Published paper: Agushaka et al.                                       %
%          A novel algorithm for global optimization: Greater cane rat    %
%          algorithm               %
%                                                                         %
%_________________________________________________________________________%

function Pos=init(SearchAgents,dimension,upperbound,lowerbound)

Boundary= size(upperbound,2); 
if Boundary==1
    Pos=rand(SearchAgents,dimension).*(upperbound-lowerbound)+lowerbound;
end

if Boundary>1
    for i=1:dimension
        ub_i=upperbound(i);
        lb_i=lowerbound(i);
        Pos(:,i)=rand(SearchAgents,1).*(ub_i-lb_i)+lb_i;
    end
end