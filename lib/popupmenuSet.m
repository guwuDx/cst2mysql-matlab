function handles = popupmenuSet(handles, popupmenu, paramDispList)

    paramInfo = handles.paramInfo;
    paramNameCell = cell(length(paramDispList), 1);
    switch handles.language
        case 'zh_CN'
            for i = 1:length(paramDispList)
                paramNameCell{i} = paramInfo(paramDispList(i)).name_zn;
            end
        case 'en_US'
            for i = 1:length(paramDispList)
                paramNameCell{i} = paramInfo(paramDispList(i)).name;
            end
        otherwise
            fprintf('[matlab][ERROR] 未知的语言选项: %s, 程序终止\n', handles.language);
            ErrFb();
    end

    set(popupmenu, 'String', paramNameCell);
    handles.paramDispList = paramDispList;