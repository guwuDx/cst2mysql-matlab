function LastIDs = LastIDs(conn, TableName, returnNum)
    sqlquery = sprintf('SELECT id FROM %s ORDER BY id DESC LIMIT %d;', TableName, returnNum);

    e = exec(conn, sqlquery);
    if ~isempty(e.Message)
        fprintf('[sql][ERROR] %s\n', e.Message);
        ErrFb();
    end

    LastIDs = fetch(e).Data;
    LastIDs = cell2mat(LastIDs);
end