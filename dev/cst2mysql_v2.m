function varargout = cst2mysql_v2(varargin)
% cst2mysql_v2 MATLAB code for cst2mysql_v2.fig
%      cst2mysql_v2, by itself, creates a new cst2mysql_v2 or raises the existing
%      singleton*.
%
%      H = cst2mysql_v2 returns the handle to a new cst2mysql_v2 or the handle to
%      the existing singleton*.
%
%      cst2mysql_v2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in cst2mysql_v2.M with the given input arguments.
%
%      cst2mysql_v2('Property','Value',...) creates a new cst2mysql_v2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cst2mysql_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cst2mysql_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above subtitle to modify the response to help cst2mysql_v2

% Last Modified by GUIDE v2.5 18-May-2024 16:08:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cst2mysql_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @cst2mysql_v2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cst2mysql_v2 is made visible.
function cst2mysql_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cst2mysql_v2 (see VARARGIN)

% Choose default command line output for cst2mysql_v2
handles.output = hObject;

% Initialize the GUI and update handles
handles = importInit(handles);

% Load the configuration file
cd('config');
strs = ini2struct('str_cst2mysql.ini');
strs = strs.(handles.language);

% Set the GUI strings
set(handles.title, 'string', strs.title);
set(handles.subtitle, 'string', strs.subtitle);
set(handles.txtPath, 'string', strs.txtPath);
set(handles.scanStart, 'string', strs.start);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cst2mysql_v2 wait for user response (see UIRESUME)
% uiwait(handles.cst2mysql);


% --- Outputs from this function are returned to the command line.
function varargout = cst2mysql_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pathBrowse.
function pathBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to pathBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selpath = uigetdir;
set(handles.pathBrowse, 'string', fullfile(selpath));


% --- Executes on selection change in shapeName.
function shapeName_Callback(hObject, eventdata, handles)%更改单元结构类型的回调函数
% hObject    handle to shapeName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function shapeName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shapeName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in scanStart.
function scanStart_Callback(hObject, eventdata, handles)%确认导出的回调函数
% hObject    handle to scanStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('[matlab][INFO] Selected path of cst result: %s\n', get(handles.pathBrowse, 'string'));

handles.mainUI = hObject;       % 记录主界面句柄
set(handles.pathBrowse, 'enable', 'off');
set(handles.scanStart,'enable','off');
set(handles.scanStart,'string','Analysing...');

Path = get(handles.pathBrowse, 'string');
handles.Path = Path;

% 扫描文件
handles = fileScan(handles);
guidata(hObject, handles);

% 加载上面分析的文件信息
siz = handles.siz;
fileInfo = handles.fileInfo;
shapeInfo = handles.shapeInfo;
properties = handles.properties;

for fileNum = 1:siz
    if fileInfo(fileNum).prptUnSkipFlag == 1
        handles.nextFile = fileNum; % 记录下一个待处理的文件的序号

        % 跳转到文件属性设置界面
        guidata(hObject, handles);
        filePropertiesBrowser('MainHandle', hObject);
        return
    end
end

% 若不存在下一个待处理的文件则开始扫描参数是否标准符合规范
f = 0;
paramInfo = handles.paramInfo;
for fileNum = 1:siz
    fileInfo(fileNum) = paramStandardization(fileInfo(fileNum), ...
                                             paramInfo, ...
                                             shapeInfo, ...
                                             properties);
    for i = 1:fileInfo(fileNum).ParamNum
        if fileInfo(fileNum).ParamMap(i) == 0
            fileInfo(fileNum).paramUnskipFlag = 1;
            f = 1;
            break
        end
    end
end
handles.fileInfo = fileInfo;

% 若存在参数不符合规范的文件则跳转到参数设置界面
if f
    % 在param中删去已经标准化的参数以确定下拉菜单的值
    % 文件（行）扫描层面
    for fileNum = 1:siz
        if fileInfo(fileNum).paramUnskipFlag == 1
            handles.nextFile = fileNum; % 记录下一个待处理的文件的序号

            % 跳转到参数设置界面
            guidata(hObject, handles);
            paramsBrowser('MainHandle', hObject);
            return
        end
    end
end
handles = dataImport(handles, fileInfo);
guidata(hObject, handles);
importEn(handles);


% --- Executes during object creation, after setting all properties.
function mainBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mainBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function scanStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paramBrowseBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on openingFcn
function handles = importInit(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 初始化代码 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 获取当前文件路径
binPath = pwd;
cd('..');
rootPath = pwd;
addpath(rootPath);
savepath;

%% 初始化日志文件
time = datestr(now, 30);
cd('log');
diary(strcat(time, '.log'));
cd(rootPath);
% setdbprefs('Debug', 'on');

%% 加载配置文件/用户库函数 & 常数定义
disp('[matlab][INFO] Loading configuration files and user libraries...');
% 加载用户库函数，若无法加载则报错
try
    addpath('lib');
catch
    disp('[matlab][ERROR] Cannot load user libraries, please check the path, program terminated');
    ErrFb();
end

cd('config');   % 跳转到配置文件目录

% 加载import.properties配置文件
disp('[matlab][INFO] Loading import.properties...');
properties = propertiesRead('import.properties');
if isempty(properties)
    disp('[matlab][ERROR] Cannot load import.properties, please check the path, program terminated');
    % 错误提示, 程序终止
    ErrFb();
end
properties.ignoreThickness = str2double(properties.ignoreThickness);
properties.ignoreETheta = str2double(properties.ignoreETheta);

language = properties.language;

% 加载存储在json中的单元结构基本形状信息
shapeInfo = json2struct('ShapeInfo.json');

% 加载存储在json中的参数识别关键词信息
paramInfo = json2struct('ParamInfo.json');

% 加载存储在json中的参数材料信息
mtrlInfo = json2struct('Materials.json');

% 计算配置文件中相关的常数
[ShapeNum, ~] = size(shapeInfo);
ShapeNum = ShapeNum - 1;           % 减去第一位的通用参数

%% 数据库连接 & 检查
DataSrc =   properties.DataSrc;
User =      properties.User;
Pwd =       properties.Pwd;

handles.DataSrc =   DataSrc;
handles.User =      User;
handles.Pwd =       Pwd;

min_innodb_buffer_pool_size = properties.minimum_innodb_buffer_pool_size;
disp('[matlab][INFO] Connecting to the database...');
conn = database(DataSrc, User, Pwd);
if isopen(conn)
    disp('[matlab][INFO] Database connection successful');
    % 检查缓冲池大小
    e = exec(conn, 'SHOW VARIABLES LIKE ''innodb_buffer_pool_size'';');
    if ~isempty(e.Message)
        fprintf('[matlab][ERROR] %s', e.Message);
        ErrFb();
    end
    % 如果缓冲池大小不足则设置为properties中的最小值
    if str2double(fetch(e).Data{2}) < min_innodb_buffer_pool_size
        fprintf('[matlab][INFO] innodb_buffer_pool_size is less than %d, setting to %d...', min_innodb_buffer_pool_size, min_innodb_buffer_pool_size);
        e = exec(conn, sprintf('SET GLOBAL innodb_buffer_pool_size=%d;', min_innodb_buffer_pool_size));
        if ~isempty(e.Message)
            fprintf('[sql][ERROR] %s', e.Message);
            ErrFb();
        end
    end
else
    disp('[matlab][ERROR] Database connection failed, program terminated');
    % 错误提示, 程序终止
    ErrFb();
end

% 读取数据库中的S参数信息
disp('[matlab][INFO] Reading SParameter information from the database...');
sql = 'SELECT * FROM SParameter;';
res = exec(conn, sql);
if ~isempty(res.Message)
    disp('res.Message');
    ErrFb();
    return;
end
sparamInfo = fetch(res).Data;

% 解除连接释放性能
close(conn);

% 计算通用参数个数
genericParamsNum = 3 + shapeInfo(1).paramNum;

%% 将数据写入handles
N_MIR = str2double(properties.N_MIR);
M_FIR = str2double(properties.M_FIR);

% handles.Operator = Operator;
handles.binPath =          binPath;
handles.rootPath =          rootPath;
handles.properties =        properties;
handles.N_MIR =             N_MIR;
handles.M_FIR =             M_FIR;
handles.shapeInfo =         shapeInfo;
handles.paramInfo =         paramInfo;
handles.mtrlInfo =          mtrlInfo;
handles.ShapeNum =          ShapeNum;
handles.time =              time;
handles.sparamInfo =        sparamInfo;
handles.language =          language;
handles.genericParamsNum =  genericParamsNum;
cd(rootPath);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 初始化代码结束 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function importEn(handles)
set(handles.pathBrowse, 'enable', 'on');
set(handles.scanStart, 'enable', 'on');
set(handles.scanStart, 'string', 'Import');


function handles = importBlock1(handles)
set(handles.pathBrowse, 'enable', 'off');
set(handles.scanStart, 'enable', 'off');
set(handles.scanStart, 'string', 'Scanning...');


function handles = importBlock2(handles)
set(handles.pathBrowse, 'enable', 'off');
set(handles.scanStart, 'enable', 'off');
set(handles.scanStart, 'string', 'Executing...');
