function mtrlNameCell = mtrlMenuRevise(mtrlInfo, properties)

    language = properties.language;

    % 生成下拉菜单的字符串
    mtrlNameCell = cell(1, length(mtrlInfo));
    switch language
        case "zh_CN"
            for i = 1:length(mtrlInfo)
                mtrlNameCell{i} = mtrlInfo(i).name_zn;
            end
        case "en_US"
            for i = 1:length(mtrlInfo)
                mtrlNameCell{i} = mtrlInfo(i).name;
            end
        otherwise
            fprintf('[matlab][ERROR] 未知的语言选项: %s, 程序终止\n', language);
            ErrFb()
    end