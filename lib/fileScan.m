function handles = fileScan(handles)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 文件扫描 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Path = handles.Path;
    cd(Path);
    fileInfo = dir('*.txt');
    siz = size(fileInfo, 1);
    handles.siz = siz;

    ShapeNum =  handles.ShapeNum;
    shapeInfo = handles.shapeInfo;
    mtrlInfo =  handles.mtrlInfo;
    sparamInfo = handles.sparamInfo;
    N_MIR =     handles.N_MIR;
    M_FIR =     handles.M_FIR;

    mtrlNum = length(mtrlInfo);

    % 初始化FileInfoStrct其他部分
    disp('[matlab][INFO] Initializing FileInfoStrct...');
    for fileNum = 1:siz
        fileInfo(fileNum).paramUnskipFlag = 0;         % 跳过设置标志位，用户输入
        fileInfo(fileNum).Shape = '';                  % 基本的单元结构形状，用户输入+自动分析
        fileInfo(fileNum).NIR_MIR_Split = 0;           % NIR, MIR频率分割点，自动分析
        fileInfo(fileNum).MIR_FIR_Split = 0;           % MIR, FIR频率分割点，自动分析
        fileInfo(fileNum).DataLength = 0;              % 数据长度，自动分析
        fileInfo(fileNum).DataMap = zeros(1, 5);       % 数据映射矩阵，自动分析，1/2/3/4/5分别代表频率/振幅/相位/色散/冗余保留位
        fileInfo(fileNum).DataNum = 0;                 % 数据种类数量，自动分析
        fileInfo(fileNum).TextLineNum = 0;             % 文本行数，自动分析
        fileInfo(fileNum).ParamMap = zeros(1, 20);     % 参数映射矩阵，自动分析+用户输入，存储原始参数位置，数字代表见README.md
        fileInfo(fileNum).ParamNum = 0;                % 参数数目，自动分析
        fileInfo(fileNum).ParamName = cell(1, 20);     % 参数名称（文件中），自动分析
        fileInfo(fileNum).params = cell(1, 1);         % 参数名称（标准化），自动加载
        fileInfo(fileNum).paramsID = zeros(1, 1);      % 文件中参数在paramInfo的id，自动加载+用户输入
        fileInfo(fileNum).Unit = 0;                    % 频率单位，自动分析
        fileInfo(fileNum).prptUnSkipFlag = 0;          % 用户输入形状跳过标志位，自动分析
        fileInfo(fileNum).CalcDispFlag = 0;            % 计算色散标志位，自动分析
        fileInfo(fileNum).CalPhaFlag = 0;              % 计算相位标志位，自动分析
        fileInfo(fileNum).ParamStart = 17;             % 参数开始位置，自动分析，默认为17
        fileInfo(fileNum).shapeID = 0;                 % 基本单元结构形状ID，自动分析
        fileInfo(fileNum).baseMtrlID = 0;              % 基底材料ID(以数据库外键id计入)，自动分析+用户输入
        fileInfo(fileNum).cellMtrlID = 0;              % 单元结构材料ID(以数据库外键id计入)，自动分析+用户输入
        fileInfo(fileNum).sparamPos = 0;               % S参数位置，自动分析
        fileInfo(fileNum).paramLine = "";              % 参数行，自动分析
        fileInfo(fileNum).paramUnit = 1;               % 参数单位，用户输入, 1:nm, 2:um, 3:mm
    end
    disp('[matlab][INFO] Initializing done');
    
    % 打印FileInfoStrct信息
    disp('[matlab][INFO] The following files are detected: ');
    disp('||=============================================================||');
    for fileNum = 1:siz
        disp(strcat('->', fileInfo(fileNum).name));
    end
    disp('||=============================================================||');
    disp(' ');
    
    %% 开始扫描文件信息
    % 频响数据，以下简称数据(Data)
    for fileNum = 1:siz
        %% 分析文件格式
        fprintf('[matlab][INFO] Reading and Analysing: %s\n', fileInfo(fileNum).name);
        fprintf('[matlab][INFO] No.%d/%d\n', fileNum, siz);
        FilName = fileInfo(fileNum).name;
        Sam = importdata(FilName);                                     % 读取文件
        ParamsLine = Sam.textdata{1, 1};                               % 这是包含参数的那行
        FormatLine = Sam.textdata{2, 1};                               % 这是包含频率响应数据参数的那行
        fileInfo(fileNum).DataLength = length(Sam.data(:, 1));         % 一组数据的长度
        fileInfo(fileNum).DataNum = length(Sam.data(1, :));            % 数据种类数量
        fileInfo(fileNum).TextLineNum = length(Sam.textdata(:, 1));    % 文本行数


        if fileInfo(fileNum).TextLineNum < 3
            fprintf('[matlab][ERROR] The file: %s is not a standard file, please check the file format, the program will be terminated\n', FilName);
            ErrFb();
        end

        fileInfo(fileNum).paramLine = ParamsLine;                      % 参数行


        %% 如果文件名标准且符合预期prptUnSkipFlag置0
        % 拆分文件名(默认以"-"连接)
        c = 1;
        idx = 1;
        nameSegment = strings(4, 1);
        for i = 1:length(FilName)
            if FilName(i) == '-'
                nameSegment(idx) = FilName(c: i-1);
                idx = idx + 1;
                c = i + 1;
            end
        end
        nameSegment(end) = FilName(c: end);

        % 检查文件名是否符合预期
        f = zeros(1, 3);
        if isempty(nameSegment(1)) ...
        || isempty(nameSegment(2)) ...
        || isempty(nameSegment(3))
            fileInfo(fileNum).prptUnSkipFlag = 1;
        else
            % 检查逐个片段是否符合预期
            % 检查基本单元结构是否符合预期
            for i = 1:ShapeNum
                if strcmp(shapeInfo(i).name, nameSegment(1))
                    fileInfo(fileNum).Shape = shapeInfo(i).name;
                    fileInfo(fileNum).shapeID = i;
                    f(1) = 0;
                    break
                else
                    f(1) = 1;
                end
            end

            % 检查基底材料是否符合预期
            for i = 1:mtrlNum
                if strcmp(mtrlInfo(i).name, nameSegment(2))
                    fileInfo(fileNum).baseMtrlID = mtrlInfo(i).primaryKey;
                    f(2) = 0;
                    break
                else
                    f(2) = 1;
                end
            end

            % 检查单元结构材料是否符合预期
            for i = 1:mtrlNum
                if strcmp(mtrlInfo(i).name, nameSegment(3))
                    fileInfo(fileNum).cellMtrlID = mtrlInfo(i).primaryKey;
                    f(3) = 0;
                    break
                else
                    f(3) = 1;
                end
            end
        end

        % 如果文件名不符合预期, prptUnSkipFlag置1，且清除已识别到的信息
        if any(f)
            fileInfo(fileNum).prptUnSkipFlag = 1;
            fileInfo(fileNum).Shape = '';
            fileInfo(fileNum).shapeID = 0;
            fileInfo(fileNum).baseMtrlID = 0;
            fileInfo(fileNum).cellMtrlID = 0;
        end


        %% 获取参数的数目和名称
        EqNum = 0;
        EqPos = zeros(1, 20);
        ParamName = cell(1, 20);
        for k = 1:length(ParamsLine)
            CrrChar = ParamsLine(k);

            % 检测参数行中"="的位置和数量
            if CrrChar == '='
                EqNum = EqNum + 1;
                EqPos(EqNum) = k;

                % 忽略首个"=", 获取参数名称
                if EqNum > 1
                    for i = 1:15
                        if (ParamsLine(k - i) == ' ') || (ParamsLine(k - i) == '{')
                            break
                        else
                            ParamName{EqNum - 1} = strcat(ParamsLine(k - i), ParamName{EqNum - 1});
                        end
                    end
                end
            end
        end
        % 检查参数名称是否重复
        for i = 1:EqNum - 1
            for j = i + 1:EqNum - 1
                if strcmp(ParamName{i}, ParamName{j})
                    fprintf('[matlab][ERROR] The parameter name in the file: %s is repeated, please check the file format, the program will be terminated\n', FilName);
                    % 错误提示, 程序终止
                    ErrFb()
                end
            end
        end
        fileInfo(fileNum).ParamNum = EqNum - 1;       % 参数数目
        fileInfo(fileNum).ParamName = ParamName;      % 参数名称
        fileInfo(fileNum).ParamStart = EqPos(2);      % 参数开始位置
    
    
        %% 获取数据的名称和单位
        % 检验数据名称/顺序是否为预期(检验第一列数据是否为频率)
        if any(FormatLine(3:11) ~= 'Frequency')
            fprintf('[matlab][ERROR] The frequency data in the file: %s is not in the first column, please check the file format, the program will be terminated\n', FilName);
            % 错误提示, 程序终止
            ErrFb()
        end
        fileInfo(fileNum).DataMap(1) = 1;             % 频率映射到第一列
    
        % 分析频率的单位, 以便后续将单位统一为THz
        if all(FormatLine(15:17) == 'MHz')
            fileInfo(fileNum).Unit = 1e-06;
        elseif all(FormatLine(15:17) == 'GHz')
            fileInfo(fileNum).Unit = 1e-03;
        elseif all(FormatLine(15:17) == 'THz')
            fileInfo(fileNum).Unit = 1;
        elseif all(FormatLine(15:17) == 'PHz')
            fileInfo(fileNum).Unit = 1e+03;
        else
            fprintf('[matlab][ERROR] The frequency unit in the file: %s is not as expected, please check the file format, the program will be terminated\n', FilName);
            % 错误提示, 程序终止
            ErrFb()
        end
        
        % 分析数据名称
        strat = 0;
        j = 1;
        for i = 18:length(FormatLine)
            if FormatLine(i) == '['
                strat = i;
                j = j + 1;
            elseif (FormatLine(i) == ']') || (FormatLine(i) == '.')
                DataName = FormatLine(strat + 1:i - 1);
                if DataName == "Mag"
                    fileInfo(fileNum).DataMap(j) = 2;             % 振幅映射
                elseif DataName == "Pha in deg"
                    fileInfo(fileNum).DataMap(j) = 3;             % 相位映射
                elseif DataName == "Dispersion"
                    fileInfo(fileNum).DataMap(j) = 4;             % 色散映射
                end
            end
        end


        %% 分析数据的S参数信息
        l = length(FormatLine);
        for i = 18:l-2
            if strcmp(FormatLine(i: i+2), '"SZ')
                fileInfo(fileNum).sparamPos = i+2;
                for j = 1:length(sparamInfo)
                    if strcmp(FormatLine(i+2: i+16), sparamInfo{j, 2})
                        fileInfo(fileNum).sparam = j;
                        break
                    end
                end
                if fileInfo(fileNum).sparam == 0
                    fprintf('[matlab][ERROR] The S parameter in the file: %s is not as expected, please check the file format, the program will be terminated\n', FilName);
                    ErrFb()
                end
                break
            end
        end
    
    
        %% 分析频率分割点在数据中的位置(值为0代表该点在最左侧, 值为-1则代表该点在最右侧)
        % 遍历矩阵Sam.data(:,1)来找到分割点
        NIR_MIR_Split = 0;
        MIR_FIR_Split = 0;
        for i = 1:length(Sam.data(:,1))
            if Sam.data(i,1) > N_MIR && NIR_MIR_Split == 0
                NIR_MIR_Split = i - 1;
            end
            if Sam.data(i,1) > M_FIR && MIR_FIR_Split == 0
                MIR_FIR_Split = i - 1;
                break; % 找到M_FIR的分割点后就可以停止遍历
            end
        end
    
        % 处理特殊情况, 如果分割点在最左侧或最右侧
        if N_MIR >= Sam.data(end,1)
            NIR_MIR_Split = -1;
        end
        if M_FIR >= Sam.data(end,1)
            MIR_FIR_Split = -1;
        end
        fileInfo(fileNum).NIR_MIR_Split = NIR_MIR_Split;
        fileInfo(fileNum).MIR_FIR_Split = MIR_FIR_Split;
    
    
        %% 分析是否需要计算色散数据
        isPha = 0;              % 默认不具备相位数据
        isDispersion = 0;       % 默认不具备色散数据
        % 当具备相位和频率数据且不含色散数据时, 需要计算色散数据
        for i = 1:fileInfo(fileNum).DataNum
            if fileInfo(fileNum).DataMap(i) == 3
                isPha = 1;
            elseif fileInfo(fileNum).DataMap(i) == 4
                isDispersion = 1;
            end
        end
        if isPha && ~isDispersion
            fileInfo(fileNum).CalcDispFlag = 1;
        end
    
    
        %% 分析是否需要计算相位数据
        isPha = 0;              % 默认不具备相位数据
        isDispersion = 0;       % 默认不具备色散数据
        % 当具备色散和频率数据且不含相位数据时, 需要计算相位数据
        for i = 1:fileInfo(fileNum).DataNum
            if fileInfo(fileNum).DataMap(i) == 3
                isPha = 1;
            elseif fileInfo(fileNum).DataMap(i) == 4
                isDispersion = 1;
            end
        end
        if isDispersion && ~isPha
            fileInfo(fileNum).CalPhaFlag = 1;
        end
    end
    
    disp('[matlab][INFO] File scanning done');
    handles.fileInfo = fileInfo;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 文件扫描结束 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%