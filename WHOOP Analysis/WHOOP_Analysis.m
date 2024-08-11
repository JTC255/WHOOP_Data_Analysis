
%Gather Data and MetaData
cycles_data = readtable('/Users/theochiang/Desktop/WHOOP Analysis/WHOOP Data/physiological_cycles.csv');
cycles_metadata = cycles_data.Properties;
cycles_col_names = cycles_metadata.VariableNames;
cycles_col_descriptions = cycles_metadata.VariableDescriptions;

%awdawd
disp(cycles_col_names(8:12))

% Extract the relevant columns for regression
% Assuming 'Day Strain' is in the column with name 'DayStrain' and 'Energy burned' is 'EnergyBurned'
dayStrain = cycles_data.('DayStrain');
energyBurned = cycles_data.('EnergyBurned_cal_');

%exclude nans
validIndices = ~isnan(dayStrain) & ~isnan(energyBurned) & dayStrain > 2 & energyBurned > 1000;
dayStrain= dayStrain(validIndices);
energyBurned = energyBurned(validIndices);


% Perform linear regression
X = [ones(length(dayStrain),1), dayStrain]; % Add a column of ones for the intercept term
b = X \ energyBurned; % Linear regression to find coefficients
disp(X)

% Regression line
regressionLine = X * b;

% Plot the data points
figure;
scatter(dayStrain, energyBurned, 'b', 'filled'); % Scatter plot of the data points
hold on;
 
% Plot the regression line
%plot(dayStrain, regressionLine, 'black', 'LineWidth', 2);
%xlabel('Day Strain');
%ylabel('Energy Burned (calories)');
%title('Regression of Day Strain vs. Energy Burned');


% Annotate the highlighted point
text(16.7, 4353, "Typhoid Fever", 'FontSize', 12, 'Color', 'r');


deg = 2

%evaluating polynomail fit
[p, S] = polyfit(dayStrain, energyBurned, deg);
[energyBurned_fit, delta] = polyval(p, dayStrain,S);

% put values in a row
[dayStrain_sorted, sortIndex] = sort(dayStrain);
energyBurned_fit = energyBurned_fit(sortIndex);

plot(dayStrain_sorted, energyBurned_fit, 'r', "LineWidth",2)
plot(dayStrain_sorted, energyBurned_fit+2*delta, 'm--', dayStrain_sorted, energyBurned_fit-2*delta,'m--',"LineWidth",1)
equation_str = sprintf('y = %.3fx^%d + %.3fx +%.3f', p(1), deg,p(2),p(3));

disp("Polynomial Equation: " + equation_str)

annotation_poly = "Poly Eq: " + equation_str + "       Std Dev: " + mean(delta)
annotation('textbox',[0.14, 0.81, 0.1, 0.1],'String',annotation_poly,'FitBoxToText','on');

%resting:
x_value = 4;
y_value = p(1)*x_value^2 + p(2)*x_value + p(3);  % Calculate the corresponding y value

% Highlight the point at x = 4
plot(x_value, y_value, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g'); % Green circle, filled
plot(x_value, y_value, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'black'); % Green circle, filled
text(x_value, y_value, sprintf('  (%.1f, %.1f)', x_value, y_value), 'FontSize', 12, 'Color', 'black');

% Add labels, title, and legend
title(sprintf('Polynomial Regression (Degree %d) of Day Strain vs. Energy Burned', deg));
xlabel('Day Strain');
ylabel('Energy Burned (calories)');
title('Linear Regression of Day Strain vs. Energy Burned');
legend('Data Points', 'Linear Regression', 'Highlighted Point','Polynomial Fit');
grid on;

hold off;
