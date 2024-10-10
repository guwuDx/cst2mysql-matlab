function sqlLoadcsv(conn, dbTable, cols, csvPath)
    % 组织load data语句
    sqlLoad = ['load data local infile ''' ...
               csvPath ...
               ''' into table ' ...
               dbTable ...
               ' fields terminated by '','' enclosed by ''"'' lines terminated by ''\n'' (' cols ');'];
    % 执行load data语句
    e = exec(conn, sqlLoad);
    if ~isempty(e.Message)
        fprintf('[sql][ERROR] %s\n', e.Message);
        ErrFb();
    end
end