%_________________________________________________________________________%
% Greater Cane Rat Algorithm (GCRA)                                       %
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
%          algorithm              %
%                                                                         %
%_________________________________________________________________________%

clear all 
clc
SearchAgents=30; 
Fun_name=['F13'];  
Max_iterations=1000; 
[lowerbound,upperbound,dimension,fitness]=fun_info(Fun_name);
[Best_score,Best_pos,SHO_curve]=LGGCRA(SearchAgents,Max_iterations,lowerbound,upperbound,dimension,fitness);

figure('Position',[500 500 660 290])
%Draw search space
subplot(1,2,1);
fun_plot(Fun_name);
title('Parameter space')
xlabel('x_1');
ylabel('x_2');
zlabel([Fun_name,'( x_1 , x_2 )'])

%Draw objective space
subplot(1,2,2);
plots=semilogy(SHO_curve,'Color','g');
set(plots,'linewidth',2)
title('Objective space')
xlabel('Iterations');
ylabel('Best score');

axis tight
grid on
box on

legend(['LGGCRA'])

display(['The best optimal value of the objective function found by LGGCRA is : ', num2str(Best_score)]);

        



