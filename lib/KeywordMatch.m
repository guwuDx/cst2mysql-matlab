function Logical = KeywordMatch(Word, TargetName, ParamInfo)
    for i = 1:length(ParamInfo)
        if strcmp(TargetName, ParamInfo(i).name)
            for j = 1:length(ParamInfo(i).Keywords)
                if strcmpi(Word, ParamInfo(i).Keywords{j})
                    Logical = true;
                    return
                end
            end
            Logical = false;
            return
        end
    end
end