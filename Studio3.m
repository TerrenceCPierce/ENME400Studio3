clear
%% Y REACTIONS UPDATE VARIABLES
l = 43.625;
% Down is positive for loads
load_arr = [6.75, 62.25;
             25.13, 28.03];
support_pos_arr = [0, 9.75, 40.5, 43.625];

%% Code for Y only
% Find for each 
for i=1:length(support_pos_arr)-2
    x = support_pos_arr(i+1);

    % Find constant load values
    y(i) = 0;
    for j=1:size(load_arr,1)
        a = load_arr(j,1);
        b = l - load_arr(j,1);
        F = load_arr(j,2);
        if a>= x
            y(i) = y(i)- F*b*x*(x^2+b^2-l^2);
        else
            y(i) = y(i)- F*a*(l-x)*(x^2+a^2-2*l*x);
        end
    end
    % Find coefficients
    for j=(1:length(support_pos_arr)-2)
        a = support_pos_arr(j+1);
        b = l - support_pos_arr(j+1);
        if a>= x
            coeff(i,j) = b*x*(x^2+b^2-l^2);
        else
            coeff(i,j) = a*(l-x)*(x^2+a^2-2*l*x);
        end
    end
end
%coeff\y'*-1 %To make up positive

eq1_fact = max(coeff(1,:));
coeff(1,:) = coeff(1,:)./eq1_fact;
y(1) = y(1)./eq1_fact;

eq2_fact = max(coeff(2,:));
coeff(2,:) = coeff(2,:)./eq2_fact;
y(2) = y(2)./eq2_fact;

solved_reaction_idx = (1:length(support_pos_arr)-2)+1;
R_y(solved_reaction_idx) = coeff\y'*-1; %To make up positive

% Use sum of forces and moment
RHS(1) = sum(load_arr(:,2))-sum(R_y(solved_reaction_idx))

RHS(2) = 0;
for j=1:size(load_arr,1)
    a = load_arr(j,1);
    F = load_arr(j,2);
    RHS(2) = RHS(2)+F*a;
end
% Find coefficients
for j=solved_reaction_idx
    a = support_pos_arr(j);
    F = R_y(j);
    RHS(2) = RHS(2)-F*a;
end

LHS = [1 1;
       0 l];
R_temp = LHS\RHS'
R_y(1) = R_temp(1);
R_y(length(support_pos_arr))=R_temp(2)

%% Z REACTIONS UPDATE VARIABLES
d_wp = 8;
% Down is positive for loads
load_arr = [6.75, 2.3685;
             25.13, 26.26];
F_ux = 26.26;

%% Code for Z only
% Find for each 
for i=1:length(support_pos_arr)-2
    x = support_pos_arr(i+1);

    % Find constant load values
    z(i) = 0;
    for j=1:size(load_arr,1)
        a = load_arr(j,1);
        b = l - load_arr(j,1);
        F = load_arr(j,2);
        if a>= x
            z(i) = z(i)- F*b*x*(x^2+b^2-l^2);
        else
            z(i) = z(i)- F*a*(l-x)*(x^2+a^2-2*l*x);
        end
    end
    % Find coefficients
    for j=(1:length(support_pos_arr)-2)
        a = support_pos_arr(j+1);
        b = l - support_pos_arr(j+1);
        if a>= x
            coeff(i,j) = b*x*(x^2+b^2-l^2);
        else
            coeff(i,j) = a*(l-x)*(x^2+a^2-2*l*x);
        end
    end
end

eq1_fact = max(coeff(1,:));
coeff(1,:) = coeff(1,:)./eq1_fact;
z(1) = z(1)./eq1_fact;

eq2_fact = max(coeff(2,:));
coeff(2,:) = coeff(2,:)./eq2_fact;
z(2) = z(2)./eq2_fact;

solved_reaction_idx = (1:length(support_pos_arr)-2)+1;
R_z(solved_reaction_idx) = coeff\z'*-1 %To make up positive

% Use sum of forces and moment
RHS(1) = sum(load_arr(:,2))-sum(R_z(solved_reaction_idx))

RHS(2) = 0;
for j=1:size(load_arr,1)
    a = load_arr(j,1);
    F = load_arr(j,2);
    RHS(2) = RHS(2)+F*a;
end
RHS(2) = RHS(2)-F_ux*d_wp/2; %Comment this out to get it to equal optimalbeam

% Find coefficients
for j=solved_reaction_idx
    a = support_pos_arr(j);
    F = R_z(j);
    RHS(2) = RHS(2)-F*a;
end

LHS = [1 1;
       0 l];
R_temp = LHS\RHS'
R_z(1) = R_temp(1);
R_z(length(support_pos_arr))=R_temp(2)