% Column Sweep

clc;
clear;
close all;

tic; % starts the CPU run time timmer

% defining the grid
N = 41;
domain_size = 80e-3; % units are in metres
delta_x = domain_size / (N - 1);
delta_y = domain_size / (N - 1);


% Assigning an initial value to the temperature matrix
T = zeros(N,N);

% Putting in the Boundary Conditions
ambient_temp = 573;
T_Top = 423;  % temperature of Top Boundary
T_Bottom = 323; % temperature of Bottom Boundary
T_Right = 473;  % temperature of Right Boundary


T(1,:) = T_Top; % temperature of Top Boundary
T(N,:) = T_Bottom; % temperature of Bottom Boundary
T(:,N) = T_Right; % temperature of Right Boundary

% Convection Parameter
h = 250;
Lambda = 5;

% Getting the array of error values and number of iterations 
error_values = [];
iterations_list = [];

%Setting the iteration counter & tolerance
iterations = 0;
tolerance = 10^-6;
error = 10;

% disp(T) % Temperature matrix before any iterations

while error>tolerance
    T_old = T;  % store the previous iteration Temperature matrix

    % This loop is for nodes on the left boundary (we cannot use column sweep for them)
    for k = 2:N-1
        T(k,1) = (1/(Lambda + h*delta_x))*(h*delta_x*ambient_temp + Lambda*T(k,2));
    end  
    
    % This loop works for interior points except points on left, right boundary
    for i = 2:N-1 

        %Creating the Matrix A and Vector B
        A_matrix_column = zeros(N,N);
        B_vector_column = zeros(N,1); 

        % Top boundary (Dirichlet)
        j = 1;
        A_matrix_column(j,j) = 1;
        B_vector_column(j)   = T_Top;

        % Bottom boundary (Dirichlet)
        j = N;
        A_matrix_column(j,j) = 1;
        B_vector_column(j)   = T_Bottom;

        % Interior nodes
        for j = 2:N-1
            A_matrix_column(j,j-1) = -1;
            A_matrix_column(j,j)   = 4;
            A_matrix_column(j,j+1) = -1;            
            B_vector_column(j) = T_old(j,i-1) + T_old(j,i+1);

        end

        %Calculating the temperature of column using TDMA Solver
        T(:,i) = TDMA(A_matrix_column, B_vector_column);
    end

    %Counting the number of iterations
    iterations = iterations+1;
    iterations_list(end + 1) = iterations;

    % disp(T) %If we display here we get to see the Temperature matrix after every iteration


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

[X,Y] = meshgrid(0:delta_x:domain_size, 0:delta_y:domain_size); % We get the x,y coordinates
figure;
hold on
contourf(X, Y, flipud(T), 30);
colormap(jet); colorbar;
title("Temperature Distribution using the Column Sweep method");
xlabel("X (m)");
ylabel("Y (m)");

% Plotting the residual
figure;
plot(iterations_list, error_values, "LineWidth", 2);
xlabel("Iterations");
ylabel("Residual");
title("Convergence of Row sweep method");
grid on;


