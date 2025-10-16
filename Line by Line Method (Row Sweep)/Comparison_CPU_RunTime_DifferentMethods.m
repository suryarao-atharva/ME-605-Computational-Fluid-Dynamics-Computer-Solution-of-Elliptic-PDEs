% CPU_RunTime_Gauss_Seidel

N1 = [11 21 41];
Time1 = [0.011 0.03 0.13];

% CPU_RunTime_Gauss_Elimination

Time2 = [0.77, 1.2, 37.97];
N2 = [11, 21, 41];

% CPU_RunTime_Row_sweep

N3 = [11 21 41];
Time3 = [0.022 0.069 0.4055];

hold on
%plot(N1, Time1,"LineWidth",2,"Color",'r')
plot(N2, Time2, "LineWidth",2,"Color",'b')
plot(N3, Time3,"LineWidth",2,"Color",'g')
legend("Gauss Elimination", "Row Sweep")


xlabel("Number of grid points")
ylabel("Computation time in seconds")
title("Comparison of CPU Run Time for Row Sweep Vs. Gauss-Elimination")
grid on;
