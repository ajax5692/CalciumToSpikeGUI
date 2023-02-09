function varargout = CalciumToSpikeGUI(varargin)
% CALCIUMTOSPIKEGUI MATLAB code for CalciumToSpikeGUI.fig
%      CALCIUMTOSPIKEGUI, by itself, creates a new CALCIUMTOSPIKEGUI or raises the existing
%      singleton*.
%
%      H = CALCIUMTOSPIKEGUI returns the handle to a new CALCIUMTOSPIKEGUI or the handle to
%      the existing singleton*.
%
%      CALCIUMTOSPIKEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCIUMTOSPIKEGUI.M with the given input arguments.
%
%      CALCIUMTOSPIKEGUI('Property','Value',...) creates a new CALCIUMTOSPIKEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalciumToSpikeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalciumToSpikeGUI_OpeningFcn via
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalciumToSpikeGUI

% Last Modified by GUIDE v2.5 09-Feb-2023 15:00:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalciumToSpikeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CalciumToSpikeGUI_OutputFcn, ...
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


% --- Executes just before CalciumToSpikeGUI is made visible.
function CalciumToSpikeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalciumToSpikeGUI (see VARARGIN)

% Choose default command line output for CalciumToSpikeGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.calculateSpike,'Enable','off')
set(handles.roiExporter,'Enable','off')
set(handles.calculateDff,'BackgroundColor','green');

set(handles.cellProbabilityThreshold,'Enable','off')
set(handles.text4,'Enable','off')

load('calciumToSpikeParams.mat')
% set(handles.frameRate,'String',calciumToSpikeParams.frameRate);
set(handles.cellProbabilityThreshold,'String',calciumToSpikeParams.cellClassifierThreshold);

calciumToSpikeParams.originalCodePath = uigetdir('','Define the code repository path first');
cd(calciumToSpikeParams.originalCodePath)
save('calciumToSpikeParams.mat','calciumToSpikeParams')



% UIWAIT makes CalciumToSpikeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CalciumToSpikeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% cd('C:\Users\abhrajyoti.chakrabarti\Documents\GitHub\OASIS mods')
load('calciumToSpikeParams.mat')
cd(calciumToSpikeParams.originalCodePath)



function frameRate_Callback(hObject, eventdata, handles)
% hObject    handle to frameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameRate as text
%        str2double(get(hObject,'String')) returns contents of frameRate as a double

load('calciumToSpikeParams.mat')
calciumToSpikeParams.frameRate = str2double(get(hObject,'String'));
save('calciumToSpikeParams.mat','calciumToSpikeParams')



% --- Executes during object creation, after setting all properties.
function frameRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cellProbabilityThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to cellProbabilityThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cellProbabilityThreshold as text
%        str2double(get(hObject,'String')) returns contents of cellProbabilityThreshold as a double

load('calciumToSpikeParams.mat')
calciumToSpikeParams.cellClassifierThreshold = str2double(get(hObject,'String'));
save('calciumToSpikeParams.mat','calciumToSpikeParams')


% --- Executes during object creation, after setting all properties.
function cellProbabilityThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellProbabilityThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculateDff.
function calculateDff_Callback(hObject, eventdata, handles)
% hObject    handle to calculateDff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('calciumToSpikeParams.mat')
while calciumToSpikeParams.isDffDone == 0;
    set(handles.isDffDone,'String','df/f Calculation Ongoing','ForegroundColor','red','Fontweight', 'bold')
    [deltaff,PSNR] = ReadRawFluorAndDff(calciumToSpikeParams);
    calciumToSpikeParams.isDffDone = 1;
end

saveFilePath = uigetdir('','Save df/f data');
cd(saveFilePath)
filter = {'*.mat'};
[saveFileName,saveFilePath] = uiputfile(filter,'Specify file name to save df/f data');
save(saveFileName,'deltaff','PSNR')
calciumToSpikeParams.dffFilePath = saveFilePath;
calciumToSpikeParams.dffFileName = saveFileName;
cd(calciumToSpikeParams.originalCodePath)
calciumToSpikeParams.isDffDone = 0;
save('calciumToSpikeParams.mat','calciumToSpikeParams')


 set(handles.calculateDff,'Enable','off')
 set(handles.calculateSpike,'Enable','on')
 set(handles.calculateSpike,'BackgroundColor','green');
 set(handles.calculateDff,'BackgroundColor',[0.9290 0.6940 0.1250]);
 
 set(handles.isDffDone,'String','df/f Calculation Complete','ForegroundColor',[0,0.5,0])



% --- Executes on button press in calculateSpike.
function calculateSpike_Callback(hObject, eventdata, handles)
% hObject    handle to calculateSpike (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('calciumToSpikeParams.mat')
cd(calciumToSpikeParams.dffFilePath)
load(calciumToSpikeParams.dffFileName)

while calciumToSpikeParams.isSpikeDone == 0
    set(handles.isSpikeDone,'String','Spike Calculation Ongoing','ForegroundColor','red','Fontweight', 'bold')
    [populationSpikeMatrix, populationSpikeProbability] = GenerateSpikeProbabilityAndBinaryMatrixByOASIS(deltaff);
    calciumToSpikeParams.isSpikeDone = 1;
end

calciumToSpikeParams.isSpikeDone = 0;
filter = {'*.mat'};
[saveFileName,calciumToSpikeParams.dffFilePath] = uiputfile(filter,'Append on the existing df/f data to save binary spike data');
save(saveFileName,'populationSpikeMatrix','populationSpikeProbability','-append')
cd(calciumToSpikeParams.originalCodePath)

 set(handles.calculateSpike,'Enable','off')
 set(handles.isSpikeDone,'String','Spike Calculation Complete','ForegroundColor',[0,0.5,0])
 set(handles.calculateSpike,'Enable','off')
 set(handles.calculateSpike,'BackgroundColor',[0.9290 0.6940 0.1250]);
 
 set(handles.roiExporter,'Enable','on')
 set(handles.roiExporter,'BackgroundColor','green');
 


% --- Executes on button press in roiExporter.
function roiExporter_Callback(hObject, eventdata, handles)
% hObject    handle to roiExporter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('calciumToSpikeParams.mat')
cd(calciumToSpikeParams.dffFilePath)
fileName = uigetfile;
load(fileName)

while calciumToSpikeParams.isROIExportDone == 0
    set(handles.roiExporterText,'String','ROI Export Ongoing','ForegroundColor','red','Fontweight', 'bold')
    [xCoord,yCoord] = RoiCoordinateExporterFromSuite2p(stat,isCell,calciumToSpikeParams);
    calciumToSpikeParams.isROIExportDone = 1;
end

filter = {'*.mat'};
[saveFileName,calciumToSpikeParams.dffFilePath] = uiputfile(filter,'Append on the existing df/f data to save ROI Coordinate Data');
save(saveFileName,'xCoord','yCoord','-append')

calciumToSpikeParams.isROIExportDone = 0;
set(handles.roiExporter,'Enable','off')
set(handles.roiExporterText,'String','ROI Export Complete','ForegroundColor',[0,0.5,0])
set(handles.roiExporter,'BackgroundColor',[0.9290 0.6940 0.1250]);

cd(calciumToSpikeParams.originalCodePath)


% --- Executes on button press in resetAll.
function resetAll_Callback(hObject, eventdata, handles)
% hObject    handle to resetAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.calculateSpike,'Enable','off')
set(handles.roiExporter,'Enable','off')
set(handles.calculateDff,'Enable','on')
set(handles.calculateDff,'BackgroundColor','green');
set(handles.isDffDone,'String','df/f Not Yet Run','ForegroundColor','black','Fontweight', 'bold')
set(handles.isSpikeDone,'String','Spike Calculation Not Done','ForegroundColor',[0.7,0.7,0.7],'Fontweight', 'bold')
set(handles.calculateSpike,'BackgroundColor',[0.7 0.7 0.7]);
set(handles.roiExporterText,'String','ROI Export Not Yet Done','ForegroundColor',[0.7,0.7,0.7])
set(handles.roiExporter,'BackgroundColor',[0.7 0.7 0.7]);



% --- Executes on button press in cellProbThres.
function cellProbThres_Callback(hObject, eventdata, handles)
% hObject    handle to cellProbThres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cellProbThres
load('calciumToSpikeParams.mat')
cd(calciumToSpikeParams.originalCodePath)
calciumToSpikeParams.cellProbThres = get(hObject,'Value');
save('calciumToSpikeParams.mat','calciumToSpikeParams')
if calciumToSpikeParams.cellProbThres == 1
    set(handles.cellProbabilityThreshold,'Enable','on')
    set(handles.text4,'Enable','on')
elseif calciumToSpikeParams.cellProbThres == 0
    set(handles.cellProbabilityThreshold,'Enable','off')
    set(handles.text4,'Enable','off')
end


% --- Executes on button press in iscell2isCell.
function iscell2isCell_Callback(hObject, eventdata, handles)
% hObject    handle to iscell2isCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RENAMEiscellTOisCell
set(handles.iscell2isCell,'BackgroundColor',rand(1,3));


% --- Executes on button press in spikePool.
function spikePool_Callback(hObject, eventdata, handles)
% hObject    handle to spikePool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CompileSpikeData
set(handles.spikePool,'BackgroundColor',rand(1,3));


% --- Executes on button press in ROIPool.
function ROIPool_Callback(hObject, eventdata, handles)
% hObject    handle to ROIPool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CompileROIData
set(handles.ROIPool,'BackgroundColor',rand(1,3));
