function sqlUnL(conn)
    e = exec(conn, 'UNLOCK TABLES;');
    if ~isempty(e.Message)
        fprintf('[sql][ERROR] %s\n', e.Message);
        ErrFb();
    end
end