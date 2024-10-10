function [posTmp, paramDispList] = paramMenuRevise(crrFileInfo, paramInfo)

    posTmp = zeros(1, 20);
    paramNum = crrFileInfo.ParamNum;
    paramMap = crrFileInfo.ParamMap;
    paramDispList = crrFileInfo.paramsID;

    k = 1;
    for i = 1:paramNum
        idx = crrFileInfo.paramsID(paramNum - i + 1);
        for j = paramMap
            if paramInfo(idx).sid == j
                paramDispList(paramNum - i + 1) = [];
                break
            end
        end

        if ~paramMap(i)
            posTmp(k) = i;
            k = k + 1;
        end
    end
    posTmp = posTmp(1:k-1);