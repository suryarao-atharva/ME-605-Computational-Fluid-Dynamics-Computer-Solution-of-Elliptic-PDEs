Time = [0.77, 1.2, 37.97];
N = [11, 21, 41];

figure;
plot(N, Time, "LineWidth",2)
grid on
xlabel("Number of Grid Points")
ylabel("Computation Time")
title("CPU Run time Versus Number of Grid Points")