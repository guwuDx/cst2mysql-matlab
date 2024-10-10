function [shapesID, shapeNameCell] = shapeMenuRevise(crrFileInfo, shapeInfo, properties)

    language = properties.language;
    ignoreThickness = properties.ignoreThickness;
    ignoreETheta = properties.ignoreETheta;

    % 首次根据参数数目匹配可能的形状，初始化下拉菜单
    fileName = crrFileInfo.name;
    shapesID = selectFromStruct("paramNum", ...
                                shapeInfo, ...
                                crrFileInfo.ParamNum + ignoreThickness + ignoreETheta);
    for i = 1:length(shapesID)
        if shapesID(i) == 1
            shapesID(i) = [];
            break
        end
    end

    % 如果没有匹配的形状id, 则报错
    if isempty(shapesID)
        fprintf('[matlab][ERROR] 文件: %s 的参数数目不符合预期, 请检查文件格式, 程序终止\n', fileName);
        ErrFb()
    end
    
    % 生成下拉菜单的字符串
    l = length(shapesID);
    shapeNameCell = cell(1, l);
    switch language
        case "zh_CN"
            for i = 1:l
                shapeNameCell{i} = shapeInfo(shapesID(i)).zn;
            end
        case "en_US"
            for i = 1:l
                shapeNameCell{i} = shapeInfo(shapesID(i)).name;
            end
        otherwise
            fprintf('[matlab][ERROR] 未知的语言选项: %s, 程序终止\n', language);
            ErrFb()
    end