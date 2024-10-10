function sqlLock(conn, tables)
    for i = 1:length(tables)
        sql = sprintf('LOCK TABLES %s WRITE', tables{i});
        e = exec(conn, sql);
        if ~isempty(e.Message)
            fprintf('[sql][ERROR] %s\n', e.Message);
            ErrFb();
        end
    end
end