function x = GaussElimination(a,b)

%Forward Substitution

size_of_matrix = size(a);
n = size_of_matrix(1,1);

A = [a b];
for i  = 1:n
    for j = i+1:n
        factor = A(j,i)/A(i,i);
        A(j,:) = A(j,:) - factor * A(i,:);
    end
end
% disp(A)


%Back substitution

a_final = A(:,1:end-1);
b_final = A(:,end);

disp(a_final)
disp(b_final)

x = zeros(n,1); % setting the solution matrix

x(n,1) = b_final(n,1)/a_final(n,n); % for any matrix x(n,1) will be calculated in this way
for i = n-1:-1:1
    sum = 0;
    for j = i+1:n
        sum = sum + a_final(i,j)*x(j,1);
    end
    x(i,1) = (b_final(i,1)- sum)/a_final(i,i);
end
% disp(x) %Final Solution of the equation 

end


