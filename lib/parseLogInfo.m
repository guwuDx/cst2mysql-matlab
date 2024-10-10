function result = parseLogInfo(fileName)
    % 打开日志文件
    fileID = fopen(fileName, 'r');
    if fileID == -1
        error('无法打开文件：%s', fileName);
    end
    
    % 初始化结果数组
    i = 1;
    result = strings(1, 4);
    % 逐行读取文件
    while ~feof(fileID)
        line = fgetl(fileID);
        % 查找开头为 "!!" 的行
        if length(line) > 3 && line(1:3) == "!! "
            % 提取并分割信息
            result(i, :) = strsplit(line(4:end), '-');
            i = i + 1;
        end
    end
    fclose(fileID);
end
