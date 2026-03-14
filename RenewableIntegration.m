% Renewable Energy - Simplified Solar Model

classdef RenewableIntegration
    properties
        solar_capacity
        solar_profile
    end
    
    methods
        function obj = RenewableIntegration(solar_kw)
            if nargin < 1
                solar_kw = 500; % Default 500 kW
            end
            obj.solar_capacity = solar_kw;
            fprintf('Solar system: %d kW\n', solar_kw);
        end
        
        function [obj, profile] = generateSolarProfile(obj)
            % Generate realistic solar power throughout the day
            
            hours = 24;
            profile = zeros(hours, 1);
            
            % Sun rises at 6 AM, sets at 8 PM (summer day)
            for h = 1:hours
                if h >= 6 && h <= 20
                    % Bell curve for solar production
                    % Peak at noon (hour 13)
                    noon = 13;
                    profile(h) = obj.solar_capacity * exp(-((h - noon)^2) / 18);
                end
            end
            
            obj.solar_profile = profile;
            
            fprintf('Solar profile generated\n');
            fprintf('Daily solar energy: %.1f kWh\n', sum(profile));
            fprintf('Peak solar power: %.1f kW at noon\n', max(profile));
        end
        
        function [savings, co2_reduction] = analyzeBenefit(obj, ev_demand)
            % Calculate how much solar helps
            
            % Energy from grid vs solar
            grid_energy = max(0, ev_demand - obj.solar_profile);
            solar_used = ev_demand - grid_energy;
            
            % Cost comparison
            grid_price = 0.15; % average €/kWh
            solar_price = 0.02; % very cheap
            
            cost_with_solar = sum(grid_energy) * grid_price + sum(solar_used) * solar_price;
            cost_without_solar = sum(ev_demand) * grid_price;
            
            savings = cost_without_solar - cost_with_solar;
            
            % CO2 reduction
            co2_grid = 0.35; % kg CO2/kWh
            co2_solar = 0.05; % much cleaner
            
            co2_without = sum(ev_demand) * co2_grid;
            co2_with = sum(grid_energy) * co2_grid + sum(solar_used) * co2_solar;
            
            co2_reduction = co2_without - co2_with;
            
            fprintf('\n=== Renewable Benefits ===\n');
            fprintf('Daily Cost Savings: €%.2f\n', savings);
            fprintf('Annual Savings: €%.2f\n', savings * 365);
            fprintf('CO2 Reduction: %.1f kg/day\n', co2_reduction);
            fprintf('Annual CO2 Reduction: %.1f tons\n', co2_reduction * 365 / 1000);
        end
        
        function plotSolar(obj, ev_demand)
            % Visualize solar production
            
            figure('Position', [100 100 900 400]);
            
            hours = 1:24;
            
            % Energy sources
            area(hours, [obj.solar_profile, max(0, ev_demand - obj.solar_profile)]);
            xlabel('Hour of Day');
            ylabel('Power (kW)');
            title('EV Charging Energy Sources');
            legend('Solar', 'Grid', 'Location', 'best');
            grid on;
        end
    end
end