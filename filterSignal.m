function signal_filtered = filterSignal(filter, signal, TS, dim)
    C = size(signal, 2);
    R = size(signal, 1);
    signal_filtered = zeros(R, C);
    
    if dim == 2
        t = TS * (0:(C-1));
        for i = 1:R
            signal_filtered(i,:) = lsim(filter, signal(i,:), t);
        end
    else
        t = TS * (0:(R-1));
        for i = 1:C
            signal_filtered(:,i) = lsim(filter, signal(:,i), t);
        end
    end
end

