function strc = json2struct(jsonFile)
    fid = fopen(jsonFile, 'r');
    if fid == -1
        fprintf('[matlab][ERROR] 无法打开文件: %s, 请检查文件路径, 程序终止\n', jsonFile);
        ErrFb();    % 错误提示, 程序终止
    end
    strc = jsondecode(fread(fid, inf, '*char').');
    fclose(fid);

    % 如果返回结果不是struct, 报错
    if ~isstruct(strc)
        fprintf('[matlab][ERROR] 文件: %s 的内容不符合预期, 请检查文件格式, 程序终止\n', jsonFile);
        ErrFb();    % 错误提示, 程序终止
    end