function [num, den] = butterworth(varargin)
%BUTTERWORTH Create a Butterworth low-pass filter of grade n that cut at the frequency omega
% arg(1) = filter degree
% arg(2) = omega || [omega1, omega2]
% arg(3) = type <"low", "high", "band", "notch">
    
    if nargin < 2
        error("Insufficient arguments");
    elseif nargin <= 3
        n = varargin{1};
        omega = varargin{2};
        if nargin == 3
            type = varargin{3};
            if type ~= "low" && type ~= "high" && type ~= "band" && type ~= "notch"
                error("Wrong type argument");
            end
            
            if type == "band"
               omega1 = omega(1);
               omega2 = omega(2);  
            end
        else
            type = "null";
        end
    else
        error("Too much arguments");
    end
    
    if type == "band"
        [num1, den1] = butterworth(n, omega1, "high");
        [num2, den2] = butterworth(n, omega2, "low");
        num = conv(num1, num2);
        den = conv(den1, den2);
    elseif type == "notch"
        [~, den] = butterworth(2*n, omega);
        num = 1;
        for k = 1:n
           num = conv(num, [1 0 omega^2]); 
        end
    else
        l = floor(n/2);
        s = zeros(l,1);
        den = 1;
        for k = 1:l
            s(k) = exp(1i * ( (2*k + n - 1)/(2*n) ) * pi);
            re = real(s(k));
            im = imag(s(k));
            d0 = omega^2 * (re^2 + im^2);
            d1 = -2 * omega * re;
            den = conv(den, [1 d1 d0]);
        end
        if mod(n,2) == 1
            den = conv(den, [1 omega]);
        end
        
        if type == "high"
            num = zeros(1, n+1);
            num(1) = 1;
        else
            num = omega^n;
        end
    end
end

