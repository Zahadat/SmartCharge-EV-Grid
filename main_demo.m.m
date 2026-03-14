% ========================================
% SMART EV CHARGING SYSTEM - MAIN DEMO
% Beginner-Friendly Complete Demonstration
% ========================================

clear all; close all; clc;

fprintf('╔═══════════════════════════════════════════════════╗\n');
fprintf('║   SMART EV CHARGING GRID INTEGRATION SYSTEM      ║\n');
fprintf('║   Beginner-Friendly Demo                         ║\n');
fprintf('╚═══════════════════════════════════════════════════╝\n\n');

% Add all paths
addpath('src/grid_analysis');
addpath('src/optimization');
addpath('src/renewable_integration');

%% PART 1: GRID IMPACT ANALYSIS
fprintf('\n========== PART 1: GRID IMPACT ANALYSIS ==========\n');
pause(1);

% Create analyzer
gridAnalyzer = GridAnalysis();

% Test different numbers of EVs
ev_counts = [10, 20, 30, 40, 50];
impacts = cell(length(ev_counts), 1);

for i = 1:length(ev_counts)
    fprintf('\nTesting %d EVs...\n', ev_counts(i));
    impacts{i} = gridAnalyzer.analyzeEVImpact(ev_counts(i));
    pause(0.5);
end

% Plot comparison
figure('Position', [100 100 1000 400]);

subplot(1, 2, 1);
voltage_drops = cellfun(@(x) x.voltage_drop, impacts);
bar(ev_counts, voltage_drops);
hold on;
plot([5 55], [5 5], 'r--', 'LineWidth', 2);
xlabel('Number of EVs');
ylabel('Voltage Drop (%)');
title('Voltage Impact vs EV Count');
legend('Voltage Drop', 'Safety Limit', 'Location', 'best');
grid on;

subplot(1, 2, 2);
loadings = cellfun(@(x) x.loading, impacts);
bar(ev_counts, loadings);
hold on;
plot([5 55], [80 80], 'r--', 'LineWidth', 2);
xlabel('Number of EVs');
ylabel('Loading (%)');
title('Transformer Loading vs EV Count');
legend('Loading', 'Safety Limit', 'Location', 'best');
grid on;

fprintf('\n✓ Grid analysis complete!\n');
pause(2);

%% PART 2: CHARGING OPTIMIZATION
fprintf('\n========== PART 2: SMART CHARGING OPTIMIZATION ==========\n');
pause(1);

% Create optimizer for 30 EVs
optimizer = ChargingOptimizer(30);

% Run optimization
[schedule, savings] = optimizer.optimizeCharging();

% Plot results
optimizer.plotOptimization();

fprintf('\n✓ Optimization complete!\n');
pause(2);

%% PART 3: RENEWABLE ENERGY INTEGRATION
fprintf('\n========== PART 3: SOLAR INTEGRATION ==========\n');
pause(1);

% Create 700 kW solar system
solar = RenewableIntegration(700);

% Generate solar profile
solar_profile = solar.generateSolarProfile();

% Use optimized charging from Part 2
ev_demand = schedule.optimized;

% Analyze benefits
[solar_savings, co2_reduction] = solar.analyzeBenefit(ev_demand);

% Visualize
solar.plotSolar(ev_demand);

fprintf('\n✓ Solar analysis complete!\n');
pause(2);

%% FINAL SUMMARY
fprintf('\n\n');
fprintf('╔═══════════════════════════════════════════════════════════╗\n');
fprintf('║              COMPREHENSIVE RESULTS SUMMARY                ║\n');
fprintf('╠═══════════════════════════════════════════════════════════╣\n');
fprintf('║  GRID IMPACT (30 EVs)                                     ║\n');
fprintf('║  • Voltage Drop: %.2f%%                                   ║\n', impacts{3}.voltage_drop);
fprintf('║  • Transformer Loading: %.1f%%                            ║\n', impacts{3}.loading);
fprintf('║  • Status: %s                            ║\n', char(~impacts{3}.overloaded * "SAFE" + impacts{3}.overloaded * "OVERLOADED"));
fprintf('╠═══════════════════════════════════════════════════════════╣\n');
fprintf('║  OPTIMIZATION SAVINGS                                     ║\n');
fprintf('║  • Daily Savings: €%.2f                                  ║\n', savings);
fprintf('║  • Annual Savings: €%.2f                                 ║\n', savings * 365);
fprintf('╠═══════════════════════════════════════════════════════════╣\n');
fprintf('║  RENEWABLE BENEFITS                                       ║\n');
fprintf('║  • Solar Savings: €%.2f/day                              ║\n', solar_savings);
fprintf('║  • CO2 Reduction: %.1f kg/day                            ║\n', co2_reduction);
fprintf('║  • Annual CO2 Saved: %.1f tons                           ║\n', co2_reduction * 365 / 1000);
fprintf('╠═══════════════════════════════════════════════════════════╣\n');
fprintf('║  TOTAL IMPACT                                             ║\n');
total_daily = savings + solar_savings;
fprintf('║  • Total Daily Savings: €%.2f                            ║\n', total_daily);
fprintf('║  • Total Annual Savings: €%.2f                           ║\n', total_daily * 365);
fprintf('╚═══════════════════════════════════════════════════════════╝\n');

fprintf('\n\n🎉 DEMONSTRATION COMPLETE! 🎉\n\n');
fprintf('All modules executed successfully.\n');
fprintf('Check the figures to see your results!\n\n');

% Save results
results = struct();
results.grid_impacts = impacts;
results.optimization_savings = savings;
results.solar_savings = solar_savings;
results.co2_reduction = co2_reduction;
results.timestamp = datetime('now');

% Create results folder if it doesn't exist
if ~exist('results', 'dir')
    mkdir('results');
end

save('results/demo_results.mat', 'results');
fprintf('✓ Results saved to: results/demo_results.mat\n\n');