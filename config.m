% Configuration File - DO NOT MODIFY UNLESS YOU KNOW WHAT YOU'RE DOING
% This stores all system parameters in one place

classdef config
    properties (Constant)
        % Grid Parameters
        BASE_VOLTAGE = 11000;           % 11kV distribution network
        BASE_POWER = 5e6;               % 5 MVA base power
        GRID_FREQUENCY = 50;            % 50Hz (EU standard)
        
        % EV Charging
        CHARGER_LEVEL2_POWER = 7.2;     % kW (typical home charger)
        BATTERY_CAPACITY = 60;          % kWh (average EV)
        CHARGING_EFFICIENCY = 0.92;     % 92% charger efficiency
        
        % Renewable Energy
        SOLAR_CAPACITY = 1000;          % kW solar PV
        BESS_CAPACITY = 500;            % kWh battery storage
        BESS_POWER = 250;               % kW battery power
        BESS_EFFICIENCY = 0.95;         % 95% round-trip
        
        % Optimization
        POPULATION_SIZE = 30;           % GA population (reduced for speed)
        MAX_GENERATIONS = 50;           % GA generations (reduced for speed)
        
        % Economic
        PEAK_TARIFF = 0.25;             % €/kWh peak price
        OFF_PEAK_TARIFF = 0.10;         % €/kWh off-peak price
        CO2_GRID = 0.35;                % kg CO2/kWh from grid
        
        % Grid Limits
        MAX_VOLTAGE_DEV = 0.05;         % ±5% voltage limit
        MAX_LOADING = 0.8;              % 80% max transformer loading
    end
end