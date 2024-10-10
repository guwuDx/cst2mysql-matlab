function varargout = paramsBrowser(varargin)
% PARAMSBROWSER MATLAB code for paramsBrowser.fig
%      PARAMSBROWSER, by itself, creates a new PARAMSBROWSER or raises the existing
%      singleton*.
%
%      H = PARAMSBROWSER returns the handle to a new PARAMSBROWSER or the handle to
%      the existing singleton*.
%
%      PARAMSBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMSBROWSER.M with the given input arguments.
%
%      PARAMSBROWSER('Property','Value',...) creates a new PARAMSBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before paramsBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to paramsBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help paramsBrowser

% Last Modified by GUIDE v2.5 16-May-2024 16:41:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @paramsBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @paramsBrowser_OutputFcn, ...
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


% --- Executes just before paramsBrowser is made visible.
function paramsBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to paramsBrowser (see VARARGIN)

% Choose default command line output for paramsBrowser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.figure1, 'closereq', @CloseRequestFcn);

% UIWAIT makes paramsBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% 获取输入参数
handles.mainHandle = varargin{2};
mainHandle = guidata(handles.mainHandle);
guidata(hObject, handles);

fileNum = mainHandle.nextFile;
fileInfo = mainHandle.fileInfo;
shapeInfo = mainHandle.shapeInfo;
properties = mainHandle.properties;
mtrlInfo = mainHandle.mtrlInfo;

handles.paramInfo = mainHandle.paramInfo;
handles.language = mainHandle.language;
handles.nextFile = fileNum;
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


% 设置下拉菜单的值
[posTmp, paramDispList] = paramMenuRevise(fileInfo(fileNum), handles.paramInfo);
handles = popupmenuSet(handles, handles.paramName, paramDispList);
handles.fileInfo = fileInfo;
handles.posTmp = posTmp;

% Load the strings file
cd(handles.rootPath);
cd('config');
strs = ini2struct('str_paramsBrowser.ini');
strs = strs.(handles.language);
handles.strs = strs;

set(handles.title, 'string', strs.title);
set(handles.tip4, 'string', strs.tip4);

strs.tip1_inst = strcat(strs.tip1, fileInfo(fileNum).name);
strs.tip2_inst = strcat(strs.tip2, fileInfo(fileNum).ParamName(posTmp(1)));
strs.tip3_inst = strcat(strs.tip3, fileInfo(fileNum).paramLine);

set(handles.title, 'string', strs.title);
set(handles.tip1, 'string', strs.tip1_inst);
set(handles.tip2, 'string', strs.tip2_inst);
set(handles.tip3, 'string', strs.tip3_inst);
set(handles.tip4, 'string', strs.tip4);
set(handles.paramOK, 'string', strs.nextButton);
set(handles.addKeyword, 'string', strs.addKeyword);

system('rundll32 user32.dll,MessageBeep');
set(handles.addKeyword, 'visible', 'off');
set(handles.paramBrowseBox,'visible','on');
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = paramsBrowser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in paramOK.
function paramOK_Callback(hObject, eventdata, handles)
% hObject    handle to paramOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.paramOK,'enable','off');
set(handles.paramBrowseBox,'visible','off');
siz = handles.siz;
paramInfo = handles.paramInfo;
nextFile = handles.nextFile;
paramDispList = handles.paramDispList;
posTmp = handles.posTmp;
fileInfo = handles.fileInfo;

% 往fileInfo.ParamMap中记录下拉菜单的值
val = get(handles.paramName, 'value');
paramID = paramDispList(val);
fileInfo(nextFile).ParamMap(posTmp(1)) = paramInfo(paramID).sid;
posTmp(1) = [];

% 如果本文件的参数全部标准化则搜寻下一个待处理的文件并设置下拉菜单的值
if isempty(posTmp)
    for fileNum = nextFile + 1:siz
        if fileInfo(fileNum).paramUnskipFlag
            handles.nextFile = fileNum; % 记录下一个待处理的文件的序号
            crrFileInfo = fileInfo(fileNum);

            [posTmp, paramDispList] = paramMenuRevise(crrFileInfo, paramInfo);
            handles = popupmenuSet(handles, handles.paramName, paramDispList);

            strs.tip1_inst = strcat(handles.strs.tip1, fileInfo(fileNum).name);
            strs.tip2_inst = strcat(handles.strs.tip2, fileInfo(fileNum).ParamName(posTmp(1)));
            strs.tip3_inst = strcat(handles.strs.tip3, fileInfo(fileNum).paramLine);

            set(handles.tip1, 'string', strs.tip1_inst);
            set(handles.tip2, 'string', strs.tip2_inst);
            set(handles.tip3, 'string', strs.tip3_inst);
            set(handles.paramName, 'value', 1);
            set(handles.paramBrowseBox,'visible','on');
            set(handles.paramOK,'enable','on');
            handles.fileInfo = fileInfo;
            handles.posTmp = posTmp;
            guidata(hObject, handles);
            return
        end
    end

% 如果本文件的参数未全部标准化则继续设置下拉菜单的值
else
    paramDispList(val) = [];   % 在param中删去刚刚选择的的参数
    handles = popupmenuSet(handles, handles.paramName, paramDispList);
    set(handles.paramName, 'value', 1);
    handles.fileInfo = fileInfo;
    handles.posTmp = posTmp;

    strs.tip2_inst = strcat(handles.strs.tip2, fileInfo(nextFile).ParamName(posTmp(1)));
    set(handles.tip2, 'string', strs.tip2_inst);

    guidata(hObject, handles);
    set(handles.paramBrowseBox,'visible','on');
    set(handles.paramOK,'enable','on');
    return
end
mainHandle = guidata(handles.mainUI);
set(mainHandle.scanStart, 'string', 'Importing...');
set(handles.paramBrowseBox,'visible','off');
handles = dataImport(handles, fileInfo);
guidata(hObject, handles);
close(handles.figure1);


% --- Executes on selection change in paramName.
function paramName_Callback(hObject, eventdata, handles)
% hObject    handle to paramName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns paramName contents as cell array
%        contents{get(hObject,'Value')} returns selected item from paramName


% --- Executes during object creation, after setting all properties.
function paramName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paramName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% close request function
function CloseRequestFcn(hObject, eventdata, ~)
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handle = guidata(hObject);
mainHandle = guidata(handle.mainUI);

set(mainHandle.pathBrowse, 'enable', 'on');
set(mainHandle.scanStart, 'enable', 'on');
set(mainHandle.scanStart, 'string', 'Start');
delete(hObject);
