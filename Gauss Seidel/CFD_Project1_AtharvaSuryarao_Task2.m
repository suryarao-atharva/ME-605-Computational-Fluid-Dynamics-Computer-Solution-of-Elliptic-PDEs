clc;
clear;

tic % start the timer for checking the cpu run time

% Defining the mesh

N = 41; % Number of grid points
domain_size = 80*10^-3;  % units are in m
delta_x = domain_size/(N-1);
delta_y = domain_size/(N-1);

% Assigning an initial value to the temperature matrix
T = zeros(N,N);

% Putting in the Boundary Conditions
ambient_temp = 573;
T(1,:) = 423; % temperature of Top Boundary
T(N,:) = 323; % temperature of Bottom Boundary
T(:,N) = 473; % temperature of Right Boundary

disp(T)

% Convection Parameter
h = 250;
Lambda = 5;

% Initializing the Error and iteration counter;
error = 10;
tolerence = 10^-6;
iterations = 0;

% Getting the array of error values and number of iterations 
error_values = [];
iterations_list = [];

% Gauss-Seidel Method

while error > tolerence
    T_old = T;

    % This loop is for interior nodes
    for i = 2:N-1
        for j = 2:N-1
            T(i,j) = 0.25.*(T(i-1,j) + T(i+1,j) + T(i,j+1) + T(i,j-1));
        end
    end  
    % This loop is for nodes on the left boundary
    for k = 2:N-1
        T(k,1) = (1/(Lambda + h*delta_x))*(h*delta_x*ambient_temp + Lambda*T(k,2));
    end

    %Counting the number of iterations
    iterations = iterations+1;
    iterations_list(end + 1) = iterations;


    % Calculating the Residual
    sum = 0;
    Temp_difference_matrix = T(1:N,1:N) - T_old(1:N,1:N);
    Temp_difference_matrix = reshape(Temp_difference_matrix,[],1);
    for k = 1:length(Temp_difference_matrix)
        sum = sum + abs(Temp_difference_matrix(k));
    end
    error = (sum)/(N^2);

    error_values(end + 1) = error;

end

elapsed_time = toc; %stopping the timer
disp("CPU run Time is:-")
disp(elapsed_time)

% Plotting the contour

figure;
[X,Y] = meshgrid(0:delta_x:domain_size, 0:delta_y:domain_size); % We get the x,y coordinates
contourf(X, Y, flipud(T), 30);
colormap(jet); colorbar;
title("Temperature Distribution using the Gauss Seidel method");
xlabel("X (m)");
ylabel("Y (m)");


% Plotting the residual
figure;
plot(iterations_list, error_values, "LineWidth", 2);
xlabel("Iterations");
ylabel("Residual");
title("Convergence of Gauss Seidel Method");
grid on;


