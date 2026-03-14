% Grid Impact Analysis - Simplified Version for Beginners
% This analyzes how EV charging affects the electricity grid

classdef GridAnalysis
    properties
        bus_data        % Stores network information
        num_evs         % Number of electric vehicles
    end
    
    methods
        function obj = GridAnalysis()
            % Constructor - runs when you create the object
            fprintf('Grid Analyzer initialized!\n');
            
            % Simplified 5-bus network (easier to understand)
            % [From_Bus To_Bus Resistance Reactance Load_kW Load_kVAR]
            obj.bus_data = [
                1  2  0.5  0.3  100  50;
                2  3  0.6  0.4  150  75;
                3  4  0.7  0.5  200  100;
                4  5  0.4  0.3  120  60;
            ];
        end
        
        function impact = analyzeEVImpact(obj, num_evs)
            % Main analysis function
            obj.num_evs = num_evs;
            
            fprintf('\n=== Analyzing %d Electric Vehicles ===\n', num_evs);
            
            % Calculate total EV load
            ev_power_per_vehicle = config.CHARGER_LEVEL2_POWER;
            total_ev_power = num_evs * ev_power_per_vehicle;
            
            % Base load (without EVs)
            base_load = sum(obj.bus_data(:, 5));
            
            % Calculate voltage drop (simplified formula)
            % More EVs = bigger voltage drop
            voltage_drop_percent = (total_ev_power / base_load) * 2.5;
            
            % Calculate transformer loading
            total_load = base_load + total_ev_power;
            transformer_capacity = 1000; % kVA
            loading_percent = (total_load / transformer_capacity) * 100;
            
            % Store results
            impact.num_evs = num_evs;
            impact.total_ev_power = total_ev_power;
            impact.voltage_drop = voltage_drop_percent;
            impact.loading = loading_percent;
            impact.overloaded = loading_percent > 80;
            
            % Display results
            fprintf('Total EV Power: %.1f kW\n', total_ev_power);
            fprintf('Voltage Drop: %.2f%%\n', voltage_drop_percent);
            fprintf('Transformer Loading: %.1f%%\n', loading_percent);
            
            if impact.overloaded
                fprintf('⚠️  WARNING: Transformer overloaded!\n');
            else
                fprintf('✓ System operating within safe limits\n');
            end
        end
        
        function plotResults(obj, impact)
            % Create visualization
            figure('Position', [100 100 800 600]);
            
            % Create bar chart
            categories = {'Voltage Drop (%)', 'Loading (%)'};
            values = [impact.voltage_drop, impact.loading];
            limits = [5, 80]; % Safe limits
            
            bar(values);
            hold on;
            plot([0.5 2.5], [limits(1) limits(1)], 'r--', 'LineWidth', 2);
            plot([0.5 2.5], [limits(2) limits(2)], 'r--', 'LineWidth', 2);
            
            set(gca, 'XTickLabel', categories);
            ylabel('Percentage');
            title(sprintf('Grid Impact Analysis - %d EVs', impact.num_evs));
            legend('Actual', 'Safety Limit', 'Location', 'best');
            grid on;
            
            % Add text labels
            for i = 1:length(values)
                text(i, values(i), sprintf('%.1f', values(i)), ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'bottom');
            end
        end
    end
end
