function varargout = filePropertiesBrowser(varargin)
% FILEPROPERTIESBROWSER MATLAB code for filePropertiesBrowser.fig
%      FILEPROPERTIESBROWSER, by itself, creates a new FILEPROPERTIESBROWSER or raises the existing
%      singleton*.
%
%      H = FILEPROPERTIESBROWSER returns the handle to a new FILEPROPERTIESBROWSER or the handle to
%      the existing singleton*.
%
%      FILEPROPERTIESBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILEPROPERTIESBROWSER.M with the given input arguments.
%
%      FILEPROPERTIESBROWSER('Property','Value',...) creates a new FILEPROPERTIESBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filePropertiesBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filePropertiesBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filePropertiesBrowser

% Last Modified by GUIDE v2.5 13-Aug-2024 16:26:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filePropertiesBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @filePropertiesBrowser_OutputFcn, ...
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


% --- Executes just before filePropertiesBrowser is made visible.
function filePropertiesBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filePropertiesBrowser (see VARARGIN)

% Choose default command line output for filePropertiesBrowser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.figure1, 'closereq', @CloseRequestFcn);

% UIWAIT makes filePropertiesBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.isFinish = 0;

% 获取输入参数
handles.mainHandle = varargin{2};
mainHandle = guidata(handles.mainHandle);
guidata(hObject, handles);

fileNum = mainHandle.nextFile;
fileInfo = mainHandle.fileInfo;
mtrlInfo = mainHandle.mtrlInfo;
shapeInfo = mainHandle.shapeInfo;
properties = mainHandle.properties;

handles.nextFile = fileNum;
handles.fileInfo = fileInfo;
handles.mtrlInfo = mtrlInfo;
handles.shapeInfo = shapeInfo;
handles.properties = properties;
handles.siz = mainHandle.siz;
handles.time = mainHandle.time;
handles.Path = mainHandle.Path;
handles.mainUI = mainHandle.mainUI;
handles.language = mainHandle.language;
handles.binPath = mainHandle.binPath;
handles.rootPath = mainHandle.rootPath;
handles.paramInfo = mainHandle.paramInfo;
handles.sparamInfo = mainHandle.sparamInfo;
handles.genericParamsNum = mainHandle.genericParamsNum;

% Load the strings file
cd(handles.rootPath);
cd('config');
strs = ini2struct('str_filePropertiesBrowser.ini');
strs = strs.(handles.language);
handles.strs = strs;

set(handles.title, 'string', strs.title);
set(handles.cellShapeText, 'string', strs.cellShapeText);
set(handles.baseMtrlText, 'string', strs.baseMtrlText);
set(handles.cellMtrlText, 'string', strs.cellMtrlText);
set(handles.unitText, 'string', strs.unitText);
set(handles.autoSelect, 'string', strs.autoSelect);
set(handles.linkButton, 'string', strs.linkButton);
set(handles.filePropertiesOK, 'string', strs.nextButton);

% 设置形状下拉菜单的值
[shapesID, shapeNameCell] = shapeMenuRevise(fileInfo(fileNum), shapeInfo, properties);
set(handles.shapeName, 'string', shapeNameCell);
handles.shapeNameCell = shapeNameCell;
handles.shapesID = shapesID;

% 设置材料下拉菜单的值
mtrlNameCell = mtrlMenuRevise(mtrlInfo, properties);
set(handles.baseMtrl, 'string', mtrlNameCell);
set(handles.cellMtrl, 'string', mtrlNameCell);
set(handles.unit, 'string', {'nm', 'um', 'mm'});

% 设置提示信息
strs.tip1 = strcat(strs.tip1, fileInfo(fileNum).name);
strs.tip2 = strcat(strs.tip2, fileInfo(fileNum).paramLine);

set(handles.tip1, 'string', strs.tip1);
set(handles.tip2, 'string', strs.tip2);

set(handles.filePropertiesBrowseBox,'visible','on');
system('rundll32 user32.dll,MessageBeep');
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = filePropertiesBrowser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in shapeName.
function shapeName_Callback(hObject, eventdata, handles)
% hObject    handle to shapeName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns shapeName contents as cell array
%        contents{get(hObject,'Value')} returns selected item from shapeName


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


% --- Executes on button press in filePropertiesOK.
function filePropertiesOK_Callback(hObject, eventdata, handles)
% hObject    handle to filePropertiesOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 加载文件信息
set(handles.filePropertiesOK,'enable','off');
set(handles.filePropertiesBrowseBox,'visible','off');
siz = handles.siz;
strs = handles.strs;
nextFile = handles.nextFile;
shapesID = handles.shapesID;
fileInfo = handles.fileInfo;
mtrlInfo = handles.mtrlInfo;
shapeInfo = handles.shapeInfo;
properties = handles.properties;

fprintf('[user][INFO] The properties of the file %s are set to:\n', fileInfo(nextFile).name);

% 往fileInfo中记录各个下拉菜单的值
val = get(handles.shapeName, 'value');
shapeID = shapesID(val);
fileInfo(nextFile).shapeID = shapeID;
fileInfo(nextFile).Shape = shapeInfo(shapeID).name;
fprintf('             Shape: %s\n', fileInfo(nextFile).Shape);

val = get(handles.baseMtrl, 'value');
fileInfo(nextFile).baseMtrlID = mtrlInfo(val).primaryKey;
fprintf('             Base Material: %s\n', mtrlInfo(val).name);

val = get(handles.cellMtrl, 'value');
fileInfo(nextFile).cellMtrlID = mtrlInfo(val).primaryKey;
fprintf('             Cell Material: %s\n', mtrlInfo(val).name);

val = get(handles.unit, 'value');
fileInfo(nextFile).paramUnit = val;
fprintf('             Unit: %d (1 -> nm, 2 -> um, 3 -> mm)\n', val);

% 如果选择了自动设置，自动找出后面合适(参数名称/数目/排列完全一样)的文件
if get(handles.autoSelect, 'value')
    for fileNum = nextFile:siz - 1
        j = 0;
        if fileInfo(nextFile).ParamNum == fileInfo(fileNum + 1).ParamNum
            for i = 1:fileInfo(nextFile).ParamNum
                if ~strcmp(fileInfo(nextFile).ParamName{i}, fileInfo(fileNum + 1).ParamName{i})
                    break
                end
                j = j + 1;
            end
        end
        if j == fileInfo(nextFile).ParamNum
            fileInfo(fileNum + 1).prptUnSkipFlag = 0;
            fileInfo(fileNum + 1).shapeID        = shapeID;
            fileInfo(fileNum + 1).Shape          = shapeInfo(shapeID).name;
            fileInfo(fileNum + 1).baseMtrlID     = fileInfo(nextFile).baseMtrlID;
            fileInfo(fileNum + 1).cellMtrlID     = fileInfo(nextFile).cellMtrlID;
            fileInfo(fileNum + 1).paramUnit      = fileInfo(nextFile).paramUnit;
            fprintf('[user][INFO] The properties of the file %s are automatically set to:\n', fileInfo(fileNum + 1).name);
            fprintf('             Shape: %s\n', fileInfo(fileNum + 1).Shape);
            fprintf('             Base Material: %s\n', mtrlInfo(fileInfo(nextFile).baseMtrlID).name);
            fprintf('             Cell Material: %s\n', mtrlInfo(fileInfo(nextFile).cellMtrlID).name);
            fprintf('             Unit: %d (1 -> nm, 2 -> um, 3 -> mm)\n', fileInfo(nextFile).paramUnit);
        else
            break
        end
    end
end


% 搜寻下一个待处理的文件并设置下拉菜单的值
for fileNum = nextFile + 1:siz
    if fileInfo(fileNum).prptUnSkipFlag
        [shapesID, shapeNameCell] = shapeMenuRevise(fileInfo(fileNum), shapeInfo, properties);
        set(handles.shapeName, 'string', shapeNameCell);
        set(handles.shapeName, 'value', 1);

        strs.tip1 = strcat(strs.tip1, fileInfo(fileNum).name);
        strs.tip2 = strcat(strs.tip2, fileInfo(fileNum).paramLine);
        set(handles.tip1, 'string', strs.tip1);
        set(handles.tip2, 'string', strs.tip2);

        handles.shapesID = shapesID;
        handles.shapeNameCell = shapeNameCell;
        handles.fileInfo = fileInfo;
        handles.nextFile = fileNum; % 记录下一个待处理的文件的序号
        guidata(hObject, handles);

        set(handles.filePropertiesOK,'enable','on');
        set(handles.filePropertiesBrowseBox,'visible','on');
        system('rundll32 user32.dll,MessageBeep');
        return
    end
end
handles.fileInfo = fileInfo;
guidata(hObject, handles);

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
            close(handles.figure1);
            return
        end
    end
else
    % 若不存在参数不符合规范的文件则开始导入数据
    % 导入数据
    handles.isFinish = 1;
    mainHandle = guidata(handles.mainUI);
    set(mainHandle.scanStart, 'string', 'Importing...');
    handles = dataImport(handles, fileInfo);
    cst2mysql_v2('importEn', mainHandle)
    close(handles.figure1);
end


% --- Executes on selection change in cellMtrl.
function cellMtrl_Callback(hObject, eventdata, handles)
% hObject    handle to cellMtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cellMtrl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cellMtrl


% --- Executes during object creation, after setting all properties.
function cellMtrl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellMtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in baseMtrl.
function baseMtrl_Callback(hObject, eventdata, handles)
% hObject    handle to baseMtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns baseMtrl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from baseMtrl


% --- Executes during object creation, after setting all properties.
function baseMtrl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baseMtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% close request function
function CloseRequestFcn(hObject, eventdata, ~)
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handle = guidata(hObject);
mainHandle = guidata(handle.mainUI);
if handle.isFinish
    cst2mysql_v2('importEn', mainHandle);
end
delete(hObject);


% --- Executes on selection change in unit.
function unit_Callback(hObject, eventdata, handles)
% hObject    handle to unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns unit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unit


% --- Executes during object creation, after setting all properties.
function unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
