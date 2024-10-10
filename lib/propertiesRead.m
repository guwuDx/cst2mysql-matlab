function properties = propertiesRead(fileName)

    % 打开文件
    fileID = fopen(fileName, 'r');

    % 初始化一个结构体来存储配置
    properties = struct();

    % 循环读取每一行
    while ~feof(fileID)
        line = fgetl(fileID);

        % 忽略空行和注释行
        if isempty(line) || startsWith(line, '#') || startsWith(line, ';')
            continue
        end

        % 拆分键和值
        keyValue = strsplit(line, '=');
        if length(keyValue) == 2
            key = strtrim(keyValue{1});
            value = strtrim(keyValue{2});

            % 将键值对添加到结构体中
            key = strrep(key, '-', '_');
            properties.(key) = value;
        end
    end

    % 关闭文件
    fclose(fileID);

    % 显示读取的配置
    disp(properties);
end