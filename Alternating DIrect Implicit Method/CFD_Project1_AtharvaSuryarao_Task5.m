%Alternative Direct Implicit Method

clc;
clear;
close all;

tic; % starts the CPU run time timmer

% defining the grid
N_x = 21;
N_y = 41;

domain_size = 80e-3; % units are in metres
delta_x = domain_size / (N_x - 1);
delta_y = domain_size / (N_y - 1);


% Assigning an initial value to the temperature matrix
T = zeros(N_y,N_x);

% Putting in the Boundary Conditions
ambient_temp = 573;
T_Top = 423;  % temperature of Top Boundary
T_Bottom = 323; % temperature of Bottom Boundary
T_Right = 473;  % temperature of Right Boundary


T(1,:) = T_Top; % temperature of Top Boundary
T(N_y,:) = T_Bottom; % temperature of Bottom Boundary
T(:,N_x) = T_Right; % temperature of Right Boundary

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
    for i = 2:N_y-1
        
        %first we solve using the row sweep

        %Creating the Matrix A and Vector B for row sweep
        A_matrix_row = zeros(N_x,N_x);
        B_vector_row = zeros(N_x,1);

        % Left boundary (convection) for row sweep
        j = 1;
        A_matrix_row(j,j)   = Lambda + h*delta_x;
        A_matrix_row(j,j+1) = -Lambda;
        B_vector_row(j)     = h*delta_x*ambient_temp; 

        % Interior nodes for row sweep
        for j = 2:N_x-1
            A_matrix_row(j,j-1) = -1*delta_y^2;
            A_matrix_row(j,j)   = 2*delta_x^2 + 2*delta_y^2;
            A_matrix_row(j,j+1) = -1*delta_y^2;            
            B_vector_row(j) = (T_old(i-1,j) + T_old(i+1,j))*delta_x^2;
        end
        % Right boundary (Dirichlet) for row sweep
        j = N_x;
        A_matrix_row(j,j) = 1;
        B_vector_row(j)   = T_Right;

        %Calculating the temperature of row using TDMA Solver row sweep
        T(i,:) = TDMA(A_matrix_row, B_vector_row).'; % As the TDMA gives column vector we take transpose to create a row vector
        % disp(T) If we display the T here we get to see the row by row operations
    end

    
    %Second we solve using the Column sweep

    % This loop is for nodes on the left boundary (we cannot use column sweep for them
    for k = 2:N_y-1
        T(k,1) = (1/(Lambda + h*delta_x))*(h*delta_x*ambient_temp + Lambda*T(k,2));
    end  
    
    % This loop works for interior points except points on left, right boundary for column sweep
    for i2 = 2:N_x-1 

        %Creating the Matrix A and Vector B
        A_matrix_column = zeros(N_y,N_y);
        B_vector_column = zeros(N_y,1); 

        % Top boundary (Dirichlet) for column sweep
        j2 = 1;
        A_matrix_column(j2,j2) = 1;
        B_vector_column(j2)   = T_Top;

        % Bottom boundary (Dirichlet) for column sweep
        j2 = N_y;
        A_matrix_column(j2,j2) = 1;
        B_vector_column(j2)   = T_Bottom;

        % Interior nodes for column sweep
        for j2 = 2:N_y-1
            A_matrix_column(j2,j2-1) = -1*delta_x^2;
            A_matrix_column(j2,j2)   = 2*delta_x^2 + 2*delta_y^2;
            A_matrix_column(j2,j2+1) = -1*delta_x^2;            
            B_vector_column(j2) = (T_old(j2,i2-1) + T_old(j2,i2+1))*delta_y^2;

        end

        %Calculating the temperature of column using TDMA Solver
        T(:,i2) = TDMA(A_matrix_column, B_vector_column);
    end

    %Counting the number of iterations
    iterations = iterations+1;
    iterations_list(end + 1) = iterations;

    % disp(T) %If we display here we get to see the Temperature matrix after every iteration


    % Calculating the Residual for column sweep + Row sweep
    sum = 0;
    Temp_difference_matrix = T(1:N_y,1:N_x) - T_old(1:N_y,1:N_x);
    Temp_difference_matrix = reshape(Temp_difference_matrix,[],1);
    for k = 1:length(Temp_difference_matrix)
        sum = sum + abs(Temp_difference_matrix(k));
    end
    error = (sum)/(N_x*N_y);
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
title("Temperature Distribution using the ADI method");
xlabel("X (m)");
ylabel("Y (m)");


% Plotting the residual
figure;
plot(iterations_list, error_values, "LineWidth", 2);
xlabel("Iterations");
ylabel("Residual");
title("Convergence of ADI method");
grid on;

