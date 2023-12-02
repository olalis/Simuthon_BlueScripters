% Function to validate received results
function [result] = check_size(original, calculated)
    result = 1;
    size_calc = size(calculated);
    if (size_calc(1) ~= 1 || size_calc(2) ~= 4)
        result = 0;
        return;
    end

    x_min_diff = abs(original(1) - calculated(1));
    y_min_diff = abs(original(2) - calculated(2));
    len_x_diff = abs(original(3) - calculated(3));
    len_y_diff = abs(original(4) - calculated(4));

    if (len_y_diff > 10 || len_x_diff > 10)
        result = 0;
    end
    if (x_min_diff > 10 || y_min_diff > 10)
        result = 0;
    end
end
