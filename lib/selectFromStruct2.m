function id = selectFromStruct2(col1, col2, struct, value1, value2)
    id = zeros(1, size(struct, 1));
    j = 1;
    f = 0;
    for i = 1:size(struct, 1)
        if (struct(i).(col1) == value1 ...
            && struct(i).(col2) == value2)
            id(j) = i;
            j = j + 1;
            f = 1;
        end
    end
    if f
        id = id(1:j-1);
    else
        id = [];
    end
