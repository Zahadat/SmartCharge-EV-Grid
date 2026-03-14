% Charging Optimizer - Simplified for Beginners
% This finds the best time to charge EVs to save money

classdef ChargingOptimizer
    properties
        num_evs
        schedule
    end
    
    methods
        function obj = ChargingOptimizer(num_evs)
            obj.num_evs = num_evs;
            fprintf('Optimizer created for %d EVs\n', num_evs);
        end
        
        function [obj, schedule, savings] = optimizeCharging(obj)
            % Simple optimization: charge during cheap hours
            
            hours = 24;
            
            % Electricity prices (€/kWh)
            % Cheap at night (0-7), expensive evening (17-22)
            tariff = zeros(24, 1);
            tariff(1:7) = 0.10;      % Night: cheap
            tariff(8:16) = 0.15;     % Day: medium
            tariff(17:22) = 0.25;    % Evening: expensive
            tariff(23:24) = 0.10;    % Late night: cheap
            
            % Energy needed per EV
            energy_per_ev = 20; % kWh
            
            % UNCONTROLLED: Charge immediately when arriving (6 PM)
            uncontrolled = zeros(24, 1);
            uncontrolled(18:21) = obj.num_evs * config.CHARGER_LEVEL2_POWER;
            uncontrolled_cost = sum(uncontrolled .* tariff);
            
            % OPTIMIZED: Charge during cheapest hours (night)
            optimized = zeros(24, 1);
            total_energy_needed = obj.num_evs * energy_per_ev;
            hours_needed = ceil(total_energy_needed / (obj.num_evs * config.CHARGER_LEVEL2_POWER));
            
            % Start charging at midnight (cheapest)
            optimized(1:hours_needed) = obj.num_evs * config.CHARGER_LEVEL2_POWER;
            optimized_cost = sum(optimized .* tariff);
            
            % Calculate savings
            savings = uncontrolled_cost - optimized_cost;
            savings_percent = (savings / uncontrolled_cost) * 100;
            
            schedule.uncontrolled = uncontrolled;
            schedule.optimized = optimized;
            schedule.tariff = tariff;
            
            fprintf('\n=== Optimization Results ===\n');
            fprintf('Uncontrolled Cost: €%.2f\n', uncontrolled_cost);
            fprintf('Optimized Cost: €%.2f\n', optimized_cost);
            fprintf('Daily Savings: €%.2f (%.1f%%)\n', savings, savings_percent);
            fprintf('Annual Savings: €%.2f\n', savings * 365);
            
            obj.schedule = schedule;
        end
        
        function plotOptimization(obj)
            % Visualize the optimization
            
            figure('Position', [100 100 1200 500]);
            
            hours = 1:24;
            
            % Plot 1: Load profiles
            subplot(1, 2, 1);
            bar(hours, [obj.schedule.uncontrolled, obj.schedule.optimized]);
            xlabel('Hour of Day');
            ylabel('Power (kW)');
            title('Charging Schedule Comparison');
            legend('Uncontrolled', 'Optimized', 'Location', 'best');
            grid on;
            
            % Plot 2: Electricity prices
            subplot(1, 2, 2);
            area(hours, obj.schedule.tariff, 'FaceColor', [0.3 0.7 0.9]);
            xlabel('Hour of Day');
            ylabel('Price (€/kWh)');
            title('Electricity Tariff');
            grid on;
        end
    end
end