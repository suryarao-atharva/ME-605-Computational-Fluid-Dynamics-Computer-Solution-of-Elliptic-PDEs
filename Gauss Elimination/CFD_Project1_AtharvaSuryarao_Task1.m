% Task 1 - Solve Using Gauss Elimination Methid

clc;
clear;
close all;

tic % start the timer for checking the cpu run time

% Define the grid Size and mesh
N = 11; % Number of points in x and y
    
domain_size = 80*10^-3;  % units are in m
delta_x = domain_size/(N-1);
delta_y = domain_size/(N-1);

% The source field term is zero so we don't need to intialize it

% Convection Parameter
h = 250;  % Convective heat transfer Coefficient
Lambda = 5; % Thermal Conductivity
 

% Putting in the Boundary Conditions (Note:- Temperatures are in Kelvin)

T = zeros(N,N);  %Intializing the temperature matrix

Ambient_Temp = 573; 
T(1,:) = 423; % temperature of Top Boundary
T(N,:) = 323; % temperature of Bottom Boundary
T(:,N) = 473; % temperature of Right Boundary


% Intializing Matrix A and Vector B

A = zeros(N*N,N*N); % Intializing the Matrix A
B = zeros(N*N,1); %% Intializing the Vector B


% Construct the Matrix A and Vector B

for i = 1:N
    for j = 1:N
        node = (i-1)*N + j;  % gets nodes value from 1 to N*N
        
        % Points on the Top boundary, Bottom and Right Boundary (Dirichlet Boundary Conditions)
        if i == 1 || i == N || j == N
            A(node,node) = 1;
            B(node) = T(i,j);   % Because value at boundary is known
        
        % Points on the Left boundary (Neumann Boundary Conditions)
        elseif (j == 1) && (i ~= 1) && (i ~= N) % We exclude the top left and Bottom left corner
            A(node,node)   = Lambda + h*delta_x;
            A(node,node+1) =  -Lambda;   % neighbor to the right
            B(node)        = h * delta_x * Ambient_Temp;
        
        % Interior Points
        else
            A(node, node) = -4;          % Central point (i, j)
            A(node, node-1) = 1;         % (i, j-1) left neighbor
            A(node, node+1) = 1;         % (i, j+1) right neighbor

            A(node, node-N) = 1;         % (i-1, j) top neighbor
            A(node, node+N) = 1;         % (i+1, j) bottom neighbor
            B(node) = 0;                 % Because no value is known

        end
    end
end


% Solve using Gauss Elimination
Temperature_vector = GaussElimination(A,B); 

% As we need a matrix for the temperature field we need to reshape the vector to a matrix and the reshaping should be row-wise

% Reshape into field
Temperature_field = reshape(Temperature_vector, N, N).';
Temperature_field = flipud(Temperature_field);

% Plotting the results

[X,Y] = meshgrid(0:delta_x:domain_size, 0:delta_y:domain_size); % We get the x,y coordinates

figure;
contourf(X, Y, Temperature_field, 30);
colormap(jet); colorbar;
title("Temperature Distribution using the Gauss Elimination method");
xlabel("X (m)");
ylabel("Y (m)");

% Getting the time required for execution

elasped_time = toc; %stopping the timer
disp("CPU run Time is:-")
disp(elasped_time)

