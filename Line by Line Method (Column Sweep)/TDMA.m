%% Thomas Diagonal Matrix Algorithm 
function Solution_matrix = TDMA(matrix_A,matrix_B)

A = matrix_A;  %[1 4 0; 6 2 5; 0 7 3];
B = matrix_B; %[8; 9; 10;];

n = size(A);
N = n(1);
Solution_matrix = zeros(N,1);

%Forward Substituion
for i = 2: N
    m = A(i,i-1)/A(i-1,i-1);
    A(i,i) = A(i,i) - m * A(i-1,i);
    A(i,i-1) = 0;
    B(i,1) = B(i,1) - m*B(i-1,1);
end

% Back substitution
Solution_matrix(N) = B(N)/A(N,N);
for j = N-1:-1:1
    Solution_matrix(j) = (B(j) - A(j,j+1)*Solution_matrix(j+1))/A(j,j);
end

end 

