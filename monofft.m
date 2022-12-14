function [spectrum] = monofft(varargin)
    if nargin == 1
        samples = varargin{1};
    elseif nargin == 2
        samples = varargin{1};
        dim = varargin{2};
    else
        error("Wrong arguments");
    end
    
    if(nargin == 1)
        N = size(samples, 1) * size(samples, 2);    % Numero campioni
        S = fft(samples);                           % Spettro
    else
        N = size(samples, dim);                     % Numero campioni
        S = fft(samples, N, dim);                   % Spettro
    end
    
    P2s = abs(S)/N;                         % Spettro bilaterale del segnale
    P1s = P2s(:, 1:N/2);                    % Spettro monolaterale del segnale
    P1s(:, 2:end-1) = 2*P1s(:, 2:end-1);    % Correzione in ampiezza dello spettro monolaterale
    
    spectrum = P1s;
end

