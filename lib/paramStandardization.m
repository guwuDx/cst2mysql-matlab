function crrFileInfo = paramStandardization(crrFileInfo, paramInfo, shapeInfo, properties)

ignoreETheta = properties.ignoreETheta;
ignoreThickness = properties.ignoreThickness;

% crrFileInfo = fileInfo(fileNum);

l = shapeInfo(crrFileInfo.shapeID).paramNum;
ParamArray = cell(l, 1);
ParamArray(1:length(shapeInfo(1).colnames)) = shapeInfo(1).colnames;

% 不得改变shapeInfo.json中GeneralParamsName的colnames字段参数顺序
% 如果需要添加通用参数请在此处if顶上再写if ↓
if ignoreETheta
    ParamArray(4) = [];
end
if ignoreThickness
    ParamArray(3) = [];
end

ParamArray(length(shapeInfo(1).colnames) - ignoreETheta - ignoreThickness + 1: ...
           shapeInfo(crrFileInfo.shapeID).paramNum - ignoreETheta - ignoreThickness) = ...
           shapeInfo(crrFileInfo.shapeID).colnames;
crrFileInfo.params = ParamArray;

paramsID = zeros(1, length(ParamArray));
crrFileInfo.paramsID = paramsID;


for i = 1:crrFileInfo.ParamNum
    % 在paramInfo中查找 "该形状应有的参数的ID" 并写入paramsID
    for j = 1:length(paramInfo)
        if strcmp(ParamArray{i}, paramInfo(j).name)
            crrFileInfo.paramsID(i) = j;
            break
        end
    end

    % 识别 "文件中的" 参数名是否已经标准化
    for j = 1:crrFileInfo.ParamNum
        if KeywordMatch(crrFileInfo.ParamName{i}, ...
                        ParamArray{j}, ...
                        paramInfo)
            for k = 1:length(paramInfo)
                if strcmp(ParamArray{j}, paramInfo(k).name)
                    crrFileInfo.ParamMap(i) = paramInfo(k).sid;
                    break
                end
            end
            break
        end
    end
end
