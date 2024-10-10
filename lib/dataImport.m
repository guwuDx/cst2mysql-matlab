function handles = dataImport(handles, fileInfo)

genericParamsNum = handles.genericParamsNum;
properties =    handles.properties;
shapeInfo =     handles.shapeInfo;
Path =          handles.Path;
siz =           handles.siz;
sparamInfo =    handles.sparamInfo;

DataSrc =       properties.DataSrc;
User =          properties.User;
Pwd =           properties.Pwd;

ignoreThickness = properties.ignoreThickness;
defaultThickness = properties.defaultThickness;

ignoreETheta = properties.ignoreETheta;
defaultETheta = properties.defaultETheta;

for fileNum = 1:siz

    %% 先将数据整理为矩阵形式
    cd(Path);
    %% 加载以上分析的部分参数信息
    DataLength =        fileInfo(fileNum).DataLength;
    DataMap =           fileInfo(fileNum).DataMap;
    textLineNum =       fileInfo(fileNum).TextLineNum;
    ParamMap =          fileInfo(fileNum).ParamMap;
    NIR_MIR_Split =     fileInfo(fileNum).NIR_MIR_Split;
    MIR_FIR_Split =     fileInfo(fileNum).MIR_FIR_Split;
    DataNum =           fileInfo(fileNum).DataNum;
    ParamNum =          fileInfo(fileNum).ParamNum;
    ParamStart =        fileInfo(fileNum).ParamStart;
    shapeID =           fileInfo(fileNum).shapeID;
    sparamPos =         fileInfo(fileNum).sparamPos;


    %% 打开文件
    FileName = fileInfo(fileNum).name;
    fid = fopen(FileName, 'r');
    if fid == -1
        disp('[matlab][ERROR] Cannot open file, please check the file path and name, program terminated');
        % 错误提示, 程序终止
        ErrFb();
    end


    %% 获取所有的参数行
    fprintf('[matlab][INFO] Getting all parameter lines of file: %s...\n', FileName);
    frewind(fid);                       % 将文件指针指向文件开头
    i = 0;
    ParamLinesCell = cell(100, 1);      % 参数行单元结构
    % 当前行不是文件末尾时
    while ~feof(fid)
        i = i + 1;
        % 读取参数行
        ParamLinesCell{i} = fgetl(fid);             % 读取当前（参数）行
        for j = 1:DataLength + textLineNum - 1
            fgetl(fid);
        end
    end
    CellStructNum = i;                              % 参数行数，即该文件具有的具体参数单元结构数目


    %% 获取所有数据行和数据描述行
    fprintf('[matlab][INFO] Getting all data lines and data description lines of file: %s...\n', FileName);
    frewind(fid);                                   % 将文件指针指向文件开头
    fgetl(fid);                                     % 跳过第一行
    DataLinesCell = cell(CellStructNum, 5);         % 其中5列是频率/振幅/相位/色散/外键预留
    DescriptionLine = cell(CellStructNum, 1);       % 数据描述行
    for i = 1:CellStructNum
        % 读取描述行
        DescriptionLine{i} = fgetl(fid);
        
        % 读取数据行
        if DataNum == 2
            DataLine = textscan(fid, '%f %f', 'Headerlines', textLineNum - 2);
            for j = 1:DataNum
                DataLinesCell{i, j} = DataLine{j};
            end
        elseif DataNum == 3
            DataLine = textscan(fid, '%f %f %f', 'Headerlines', textLineNum - 2);
            for j = 1:DataNum
                DataLinesCell{i, j} = DataLine{j};
            end
        else
            msgbox('The program is temporarily unable to process the format of file, because there are too many types of frequency response data. If this situation occurs, please ask guwudx to modify the code and terminate the program')
            fprintf('[matlab][ERROR] The program is temporarily unable to process the format of file: %s because there are too many types of frequency response data. If this situation occurs, please ask guwudx to modify the code and terminate the program\n', FileName);
            % 错误提示, 程序终止
            ErrFb();
        end
        fgetl(fid);                                % 跳过参数行
    end
    fclose(fid);


    %% 提取参数行中的参数值
    fprintf('[matlab][INFO] Extracting parameter values for file: %s\n', FileName);

    % 初始化参数值矩阵（内存分配）
    ParamArr_tmp = strings(CellStructNum, ParamNum);

    % 提取参数值
    for i = 1:CellStructNum
        j = ParamStart;
        n = 1;
        for k = ParamStart:length(ParamLinesCell{i})
            if ParamLinesCell{i}(k) == '='
                j = k + 1;
            elseif (ParamLinesCell{i}(k) == ';') || (ParamLinesCell{i}(k) == '}')
                ParamArr_tmp(i, n) = ParamLinesCell{i}(j:k - 1);
                n = n + 1;
            end
        end
    end


    %% 检测并写入S参数ID
    sparams = zeros(CellStructNum, 1);
    fprintf('[matlab][INFO] Scanning S-parameter ID for file %s\n', FileName);
    sparamsNum = length(sparamInfo);
    for i = 1:CellStructNum
        for j = 1:sparamsNum
            if strcmp(DescriptionLine{i}(sparamPos:sparamPos+14), sparamInfo{j, 2})
                sparams(i) = j;
                break
            end
        end
    end
    if any(sparams == 0)
        fprintf('[matlab][ERROR] The S-parameter ID of file %s was not detected. Please check the file format, the program terminated\n', FileName);
        ErrFb();
    end


    %% 根据映射表将参数矩阵和数据矩阵整理为标准形式（列变换为Map中值由小到大）
    ParamArr = strings(CellStructNum, 3 + shapeInfo(fileInfo(fileNum).shapeID).paramNum + 1);
    ParamArr(:, 1) = fileInfo(fileNum).baseMtrlID;
    ParamArr(:, 2) = fileInfo(fileNum).cellMtrlID;
    ParamArr(:, 3) = num2str(sparams);

    [M, N] = size(DataLinesCell);
    DataArr = cell(M, N);

    % 变换数据矩阵
    for i = 1:DataNum
        DataArr(:, DataMap(i)) = DataLinesCell(:, i);
    end
    % 统一单位为THz
    if fileInfo(fileNum).Unit ~= 1
        DataArr(:, 1) = num2cell(cell2mat(DataArr(:, 1)) .* fileInfo(fileNum).Unit);
    end

    % 变换参数矩阵
    for i = 1:ParamNum
        ParamArr(:, 3 + ParamMap(i)) = ParamArr_tmp(:, i);
    end
    if ignoreThickness
        ParamArr(:, 6) = defaultThickness;
    else % 统一单位为nm
        if fileInfo(fileNum).paramUnit ~= 1
            ParamArr(:, 6) = num2str(str2double(ParamArr(:, 6)) .* (1e3 ^ (fileInfo(fileNum).paramUnit - 1)));
        end
    end
    if ignoreETheta
        ParamArr(:, 7) = defaultETheta;
    end
    % 统一单位为nm
    if fileInfo(fileNum).paramUnit ~= 1
        ParamArr(:, 4) = num2str(str2double(ParamArr(:, 4)) .* (1e3 ^ (fileInfo(fileNum).paramUnit - 1)));
        ParamArr(:, 5) = num2str(str2double(ParamArr(:, 5)) .* (1e3 ^ (fileInfo(fileNum).paramUnit - 1)));
        for i = genericParamsNum + 1:3 + shapeInfo(fileInfo(fileNum).shapeID).paramNum
            ParamArr(:, i) = num2str(str2double(ParamArr(:, i)) .* (1e3 ^ (fileInfo(fileNum).paramUnit - 1)));
        end
    end


    %% 如果满足条件则计算色散数据
    if fileInfo(fileNum).CalcDispFlag
        fprintf('[matlab][INFO] Calculating dispersion data for file %s\n', FileName);
        % 计算色散数据
        FreqResol = DataArr{1, 1}(2) - DataArr{1, 1}(1);    % 频率分辨率
        for i = 1:CellStructNum
            for j = 1:DataLength - 1
                PhaDiff = DataArr{i, 3}(j + 1) - DataArr{i, 3}(j);
                DataArr{i, 4}(j) = PhaDiff / FreqResol;
            end
            DataArr{i, 4}(j + 1) = DataArr{i, 4}(j);
            DataArr{i, 4} = DataArr{i, 4}';
        end
    end


    %% 按文件规律合并ParamArr中3:7列完全一样的数据写在grnericParam（仅在前后两行之间比较），并将唯一ID写在其余的列右边
    k = 1;
    genericParam = strings(CellStructNum, genericParamsNum);
    for i = 1:CellStructNum - 1
        for j = 3:7
            if any(ParamArr(i, j) ~= ParamArr(i + 1, j))
                genericParam(k, :) = ParamArr(i, 1:7);
                ParamArr(i, end) = num2str(k);
                k = k + 1;
                break
            else
                ParamArr(i, end) = num2str(k);
            end
        end
    end
    genericParam(k, :) = ParamArr(end, 1:7);
    genericParam = genericParam(1:k, :);                % 裁剪genericParam矩阵
    ParamArr(end, end) = k;
    ParamArr = str2double(ParamArr(:, genericParamsNum + 1:end));


    %% 对DataArr第五列分配唯一标识(外键)
    for i = 1:CellStructNum
        DataArr{i, 5} = zeros(DataLength, 1) + i;
    end


    %% 根据频率分割点将DataArr分割为NIR、MIR、FIR三部分
    % 遍历六种分割情况以节省内存，不需要的部分不分配内存（其实是孤鹜断霞懒得动脑子想了（））
    if NIR_MIR_Split == 0 && MIR_FIR_Split == 0
        DataArr_NIR = cell2mat(DataArr);
        DataArr_MIR = [];
        DataArr_FIR = [];
    elseif NIR_MIR_Split == -1 && MIR_FIR_Split == 0
        DataArr_NIR = [];
        DataArr_MIR = cell2mat(DataArr);
        DataArr_FIR = [];
    elseif NIR_MIR_Split == -1 && MIR_FIR_Split == -1
        DataArr_NIR = [];
        DataArr_MIR = [];
        DataArr_FIR = cell2mat(DataArr);
    elseif NIR_MIR_Split ~= 0 && NIR_MIR_Split ~= -1 && MIR_FIR_Split == 0
        DataArr_NIR = cell2mat(DataArr(1:NIR_MIR_Split, :));
        DataArr_MIR = cell2mat(DataArr(NIR_MIR_Split + 1:end, :));
        DataArr_FIR = [];
    elseif NIR_MIR_Split == -1 && MIR_FIR_Split ~= 0 && MIR_FIR_Split ~= -1
        DataArr_NIR = [];
        DataArr_MIR = cell2mat(DataArr(1:MIR_FIR_Split, :));
        DataArr_FIR = cell2mat(DataArr(MIR_FIR_Split + 1:end, :));
    elseif NIR_MIR_Split ~= 0 && NIR_MIR_Split ~= -1 && MIR_FIR_Split ~= 0 && MIR_FIR_Split ~= -1
        DataArr_NIR = cell2mat(DataArr(1:NIR_MIR_Split, :));
        DataArr_MIR = cell2mat(DataArr(NIR_MIR_Split + 1:MIR_FIR_Split, :));
        DataArr_FIR = cell2mat(DataArr(MIR_FIR_Split + 1:end, :));
    end




%% 将数据导入数据库

    %% 数据库连接
    if fileNum == 1
        disp('[matlab][INFO] Connecting to database...');
        conn = database(DataSrc, User, Pwd);
        if isempty(conn.Message)
            disp('[matlab][INFO] Database connected successfully');
        else
            disp('[matlab][ERROR] Database connection failed, please check the database connection information, program terminated');
            % 错误提示, 程序终止
            ErrFb();
        end
    end
    
    
        %% 添加表锁
    %    disp('[matlab][INFO] 正在添加表锁...');
    %    tbs = [shapeInfo(1).tables(1), shapeInfo(fileInfo(fileNum).shapeID).tables(1)];
    %    sqlLock(conn, tbs);

    
    %% 将genericParam写入数据库
    disp('[matlab][INFO] Writing generic Parameters to database...');
    gen_l = size(genericParam, 1);
    genericParam = str2double(genericParam);
    dbTable = cell2mat(shapeInfo(1).tables);
    cols = [{'baseMaterial_id', 'cellMaterial_id', 'S_Param_id'}, shapeInfo(1).colnames{:}];
    genericParam = array2table(genericParam, 'VariableNames', cols);
    sqlwrite(conn, dbTable, genericParam);

    lID = LastIDs(conn, dbTable, gen_l);
    fprintf('[sql][INFO][CRUCIAL] This time the file %s is entered into the table %s, the details of the id are as follows:\n', FileName, dbTable);
    fprintf('!! %s-%s-', FileName, dbTable);
    fprintf('%d-', lID);
    fprintf('\n');


    %% 将ParamArr匹配外键后写入数据库
    disp('[matlab][INFO] Matching foreign keys for ParamArr...');
    spc_l = size(ParamArr, 1);
    for i = 1:spc_l
        ParamArr(i, end) = lID(gen_l - ParamArr(i, end) + 1);
    end

    disp('[matlab][INFO] Writing ParamArr to database...');
    dbTable = cell2mat(shapeInfo(shapeID).tables(1));
    
    particularParamNum = shapeInfo(shapeID).paramNum + 3 - genericParamsNum;
    cols = strings(1, particularParamNum + 1);
    for i = 1:particularParamNum
        cols(i) = shapeInfo(shapeID).colnames{i};
    end
    cols(1, end) = "GUP_ID";
    
    ParamArr = array2table(ParamArr, 'VariableNames', cols);
    sqlwrite(conn, dbTable, ParamArr);

    lID = LastIDs(conn, dbTable, spc_l);
    fprintf('[sql][INFO][CRUCIAL] This time the file %s is entered into the table %s, the details of the id are as follows:\n', FileName, dbTable);
    fprintf('!! %s-%s-', FileName, dbTable);
    fprintf('%d-', lID);
    fprintf('\n');


    %% 将DataArr匹配外键后写入数据库
    dbTable = cell2mat(shapeInfo(shapeID).tables(2));
    cols = {'Frequency', 'Magnitude', 'Phase_in_degree', 'Dispersion', 'UP_ID'};
    if ~isempty(DataArr_NIR)
        disp('[matlab][INFO] Matching foreign keys for DataArr(NIR)...');
        frq_l = size(DataArr_NIR, 1);
        for i = 1:frq_l
            DataArr_NIR(i, 5) = lID(spc_l - DataArr_NIR(i, 5) + 1);
        end

        disp('[matlab][INFO] Writing DataArr to database, this operation may take some time...');
        DataArr_NIR = array2table(DataArr_NIR, 'VariableNames', cols);
        dbTable = strcat(dbTable, '_nir');
        sqlwrite(conn, dbTable, DataArr_NIR);

        lID = LastIDs(conn, dbTable, frq_l);
        fprintf('[sql][INFO][CRUCIAL] This time the file %s is entered into the table %s, the details of the id are as follows:\n', FileName, dbTable);
        fprintf('!! %s-%s-', FileName, dbTable);
        fprintf('%d-', lID);
        fprintf('\n');
    else
        disp('[matlab][INFO] No near infrared (NIR) data detected, skipping');
    end
    if ~isempty(DataArr_MIR)
        disp('[matlab][INFO] Matching foreign keys for DataArr(MIR)...');
        frq_l = size(DataArr_MIR, 1);
        for i = 1:frq_l
            DataArr_MIR(i, 5) = lID(spc_l - DataArr_MIR(i, 5) + 1);
        end

        disp('[matlab][INFO] Writing DataArr to database, this operation may take some time...');
        DataArr_MIR = array2table(DataArr_MIR, 'VariableNames', cols);
        dbTable = strcat(dbTable, '_mir');
        sqlwrite(conn, dbTable, DataArr_MIR);

        lID = LastIDs(conn, dbTable, frq_l);
        fprintf('[sql][INFO][CRUCIAL] This time the file %s is entered into the table %s, the details of the id are as follows:\n', FileName, dbTable);
        fprintf('!! %s-%s-', FileName, dbTable);
        fprintf('%d-', lID);
        fprintf('\n');
    else
        disp('[matlab][INFO] No mid infrared (MIR) data detected, skipping');
    end
    if ~isempty(DataArr_FIR)
        disp('[matlab][INFO] Matching foreign keys for DataArr(FIR)...');
        frq_l = size(DataArr_FIR, 1);
        for i = 1:frq_l
            DataArr_FIR(i, 5) = lID(spc_l - DataArr_FIR(i, 5) + 1);
        end

        disp('[matlab][INFO] Writing DataArr to database, this operation may take some time...');
        DataArr_FIR = array2table(DataArr_FIR, 'VariableNames', cols);
        dbTable = strcat(dbTable, '_fir');
        sqlwrite(conn, dbTable, DataArr_FIR);

        lID = LastIDs(conn, dbTable, frq_l);
        fprintf('[sql][INFO][CRUCIAL] This time the file %s is entered into the table %s, the details of the id are as follows:\n', FileName, dbTable);
        fprintf('!! %s-%s-', FileName, dbTable);
        fprintf('%d-', lID);
        fprintf('\n');
    else
        disp('[matlab][INFO] No far infrared (FIR) data detected, skipping');
    end

        %% 解除表锁
    %    disp('[matlab][INFO] 正在解除表锁...');
    %    sqlUnL(conn);
    %    exec(conn, 'FLUSH TABLES;');
end
close(conn);

msgbox('Data Import Success!', 'Success', 'help');
disp('= [matlab][INFO] ====================================================================================');
disp('=>  Data import success!                                                                          <==');
disp('=====================================================================================================');