% CPU_RunTime_Row_sweep

N = [11 21 41];
Time = [0.022 0.069 0.4055];
plot(N, Time,"LineWidth",2,"Color",'r')
xlabel("Number of Gridpoints")
ylabel("Computation time in seconds")
title("CPU Run time Versus Number of Points")
grid on;