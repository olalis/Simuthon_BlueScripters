function [result] = check_size(original, calculated)
    result = 1;
    x_min_diff = abs(original(1) - calculated(1));
    y_min_diff = abs(original(2) - calculated(2));
    len_x_diff = abs(original(3) - calculated(3));
    len_y_diff = abs(original(4) - calculated(4));

    if (len_y_diff + len_x_diff > 10)
        result = 0;
    end
    if (x_min_diff > 10 || y_min_diff > 10)
        result = 0;
    end
end