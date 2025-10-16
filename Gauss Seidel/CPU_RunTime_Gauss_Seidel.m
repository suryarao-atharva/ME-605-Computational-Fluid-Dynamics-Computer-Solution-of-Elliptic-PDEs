% CPU_RunTime_Gauss_Seidel

N = [11 21 41];
Time = [0.011 0.03 0.13];
plot(N, Time,"LineWidth",2,"Color",'r')
xlabel("Number of iterations")
ylabel("Computation time in seconds")
title("CPU Run time Versus Number of Points")
grid on;