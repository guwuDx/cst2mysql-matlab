function id = selectFromStruct(colnames, struct, value)
    id = zeros(1, size(struct, 1));
    j = 1;
    f = 0;
    for i = 1:size(struct, 1)
        if struct(i).(colnames) == value
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
