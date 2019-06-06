function varargout = roiViewerGUI(varargin)
% ROIVIEWERGUI MATLAB code for roiViewerGUI.fig
%      ROIVIEWERGUI, by itself, creates a new ROIVIEWERGUI or raises the existing
%      singleton*.
%
%      H = ROIVIEWERGUI returns the handle to a new ROIVIEWERGUI or the handle to
%      the existing singleton*.
%
%      ROIVIEWERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROIVIEWERGUI.M with the given input arguments.
%
%      ROIVIEWERGUI('Property','Value',...) creates a new ROIVIEWERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before roiViewerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to roiViewerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help roiViewerGUI

% Last Modified by GUIDE v2.5 04-Jun-2019 10:41:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @roiViewerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @roiViewerGUI_OutputFcn, ...
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

% --- Executes just before roiViewerGUI is made visible.
function roiViewerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% varargin   command line arguments to roiViewerGUI (see VARARGIN)

global p

p.h1 = handles.axes1;
p.h2 = handles.axes2;
p.h3 = handles.axes3;

p.text_snr_filt = handles.text_snr_filt;
p.text_numstates_filt = handles.text_numstates_filt;
% Choose default command line output for roiViewerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using roiViewerGUI.
% initial load of ROI 1 at channel 1
if strcmp(get(hObject,'Visible'),'off')
    p.currentChannelIdx = 1;
    goToROI(1);
end


% --- Outputs from this function are returned to the command line.
function varargout = roiViewerGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% autogenerated and unused


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% autogenerated and unused, as the file menu calls the custom loadData function
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% loads the standard print dialog
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% autogenerated and unused, as there is no necessary "close" option in the file menu
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% changes the channel selected via popup, and remains on the current ROI.
% Supports an arbitrary number of channels
global data p 

popup_sel_index = get(handles.popupmenu1, 'Value');
for i = 1:size(data.rois,2)
    switch popup_sel_index
        case i
            p.currentChannelIdx = i;
            goToROI(p.roiIdx);
    end
end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% create the popupmenu via an external function, retrieving channel names.
% Supports an arbitraty number of channels
global p
p.channelPopupObject = hObject;
channelPopup(hObject);


% --- Executes on button press in pushbutton2_nextROI.
function pushbutton2_nextROI_Callback(hObject, eventdata, handles)
% go to the next ROI, stops at end of ts
global p
goToROI(p.roiIdx + 1);


% --- Executes on button press in pushbutton3_prevROI.
function pushbutton3_prevROI_Callback(hObject, eventdata, handles)
% go to the previous ROI, stops at 1
global p
goToROI(p.roiIdx - 1);


% --- Executes on button press in pushbutton4_customROI.
function pushbutton4_customROI_Callback(hObject, eventdata, handles)
% jump to any given ROI via a dialog
goToROI


% --- Executes on button press in pushbutton9_analyzeThis.
function pushbutton9_analyzeThis_Callback(hObject, eventdata, handles)
% sets condition to run DISC on the current ROI and brings up param dialog
global p
p.analyzeAll = 0;
analyzeDialog();


% --- Executes on button press in pushbutton11_analyzeAll.
function pushbutton11_analyzeAll_Callback(hObject, eventdata, handles)
% sets condition to run DISC on all ROIs and brings up param dialog
global p 
p.analyzeAll = 1;
analyzeDialog();



% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% handles all key presses as labeled on buttons. easily extended with the
% proper strings
switch eventdata.Key
    case 'rightarrow'
        uicontrol(handles.pushbutton2_nextROI)
        pushbutton2_nextROI_Callback(handles.pushbutton2_nextROI,[],handles)
    case 'leftarrow'
        uicontrol(handles.pushbutton3_prevROI)
        pushbutton3_prevROI_Callback(handles.pushbutton3_prevROI,[],handles)
    case 'uparrow'
        uicontrol(handles.pushbutton16_toggleSelect)
        pushbutton16_toggleSelect_Callback(handles.pushbutton16_toggleSelect,[],handles)
    case 'downarrow'
        uicontrol(handles.pushbutton17_toggleDeselect)
        pushbutton17_toggleDeselect_Callback(handles.pushbutton17_toggleDeselect,[],handles)
    case 'period'
        uicontrol(handles.pushbutton18_nextSelected)
        pushbutton18_nextSelected_Callback(handles.pushbutton18_nextSelected,[],handles)
    case 'comma'
        uicontrol(handles.pushbutton19_prevSelected)
        pushbutton19_prevSelected_Callback(handles.pushbutton19_prevSelected,[],handles)
end


% --- Executes on button press in pushbutton14_clearThis.
function pushbutton14_clearThis_Callback(hObject, eventdata, handles)
% clears analysis fields for current ROI
global data p
data.rois(p.roiIdx,p.currentChannelIdx).disc_fit = [];
data.rois(p.roiIdx,p.currentChannelIdx).SNR = [];
goToROI(p.roiIdx)

% --- Executes on button press in pushbutton15_clearAll.
function pushbutton15_clearAll_Callback(hObject, eventdata, handles)
% clears analysis fields for all ROIs
global data p
[data.rois(:,p.currentChannelIdx).disc_fit] = deal([]);
[data.rois(:,p.currentChannelIdx).SNR] = deal([]);
goToROI(p.roiIdx)


% --- Executes on button press in pushbutton16_toggleSelect.
function pushbutton16_toggleSelect_Callback(hObject, eventdata, handles)
% change "status" field for ROI and title if necessary
global data p
% change status on all channels
for ii = 1:size(data.rois,2)
    data.rois(p.roiIdx,ii).status = 1;
end
numsel = nnz(vertcat(data.rois(:,p.currentChannelIdx).status)==1); % count # of selected
if data.rois(p.roiIdx,p.currentChannelIdx).status == 1
    title(p.h1, ['ROI # ',num2str(p.roiIdx),' of ',num2str(size(data.rois,1)),...
        ' - Status: Selected','  (',num2str(numsel),' selected)']);
elseif data.rois(p.roiIdx,p.currentChannelIdx).status == 0
    title(p.h1, ['ROI # ',num2str(p.roiIdx),' of ',num2str(size(data.rois,1)),...
        ' - Status: Unselected','  (',num2str(numsel),' selected)']);
else
    title(p.h1, ['ROI # ',num2str(p.roiIdx),' of ',num2str(size(data.rois,1)),...
        ' - Status: null','  (',num2str(numsel),' selected)']);
end


% --- Executes on button press in pushbutton17_toggleDeselect.
function pushbutton17_toggleDeselect_Callback(hObject, eventdata, handles)
% change "status" field for ROI and title if necessary
global data p
% change status on all channels
for ii = 1:size(data.rois, 2)
    data.rois(p.roiIdx,ii).status = 0;
end
numsel = nnz(vertcat(data.rois(:,p.currentChannelIdx).status)==1); % count # of selected
if data.rois(p.roiIdx,p.currentChannelIdx).status == 1
    title(p.h1, ['ROI # ',num2str(p.roiIdx),' of ',num2str(size(data.rois,1)),...
        ' - Status: Selected','  (',num2str(numsel),' selected)']);
elseif data.rois(p.roiIdx,p.currentChannelIdx).status == 0
    title(p.h1, ['ROI # ',num2str(p.roiIdx),' of ',num2str(size(data.rois,1)),...
        ' - Status: Unselected','  (',num2str(numsel),' selected)']);
else
    title(p.h1, ['ROI # ',num2str(p.roiIdx),' of ',num2str(size(data.rois,1)),...
        ' - Status: null','  (',num2str(numsel),' selected)']);
end


% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% currently unused


% --- Executes on button press in pushbutton18_nextSelected.
function pushbutton18_nextSelected_Callback(hObject, eventdata, handles)
% finds next ROI with "selected" status and goes to it in the GUI
global data p    
    j = find(vertcat(data.rois(p.roiIdx+1:end,p.currentChannelIdx).status) == 1);
    if ~isempty(j) 
        goToROI(p.roiIdx + j(1)); 
    end


% --- Executes on button press in pushbutton19_prevSelected.
function pushbutton19_prevSelected_Callback(hObject, eventdata, handles)
% finds previous ROI with "selected" status and goes to it in the GUI
global data p
    j = find(vertcat(data.rois(1:p.roiIdx-1,p.currentChannelIdx).status) == 1);
    if ~isempty(j) 
        goToROI(j(end)); 
    end


% --------------------------------------------------------------------
function menuPlots_Callback(hObject, eventdata, handles)
% hObject    handle to menuPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_filter.
function pushbutton_filter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p data

params = traceSelection;
% cancel if continue is not pressed
if params.contpr ~= 1
    handles.text_snr_filt.String = 'any';
    handles.text_numstates_filt.String = 'any';
    return;
end
% if cancel is pressed, no filter will be applied, but the traces from the
% previous filtering will still be selected.

% assign min and max values if entry boxes are left empty
if ~exist('params.snr_max', 'var')
    params.snr_max = Inf;
end
if ~exist('params.snr_min', 'var')
    params.snr_min = -Inf;
end
if ~exist('params.numstates_max', 'var')
    params.numstates_max = Inf;
end
if ~exist('params.numstates_min', 'var')
    params.numstates_min = 0;
end

[data.rois.status] = deal(0); % clear any existing selections

% sort by SNR only
if params.snrEnable == 1 && params.numstatesEnable == 0
    % change corresponding text in GUI
    handles.text_snr_filt.String = [num2str(params.snr_min),...
        ' → ', num2str(params.snr_max)];
    handles.text_numstates_filt.String = 'any';
    computeSNR(0); % fill field in data struct
    % adjust trace status of parameters are met
    for ii = 1:length(data.rois)
        if ~isempty(data.rois(ii,p.currentChannelIdx).SNR)
            trace_snr = data.rois(ii,p.currentChannelIdx).SNR;
            if trace_snr <= params.snr_max && ...
                    trace_snr >= params.snr_min
                for jj = 1:size(data.rois,2)
                    data.rois(ii,jj).status = 1;
                end
            end
        end
    end
% sort by # of states only
elseif params.numstatesEnable == 1 && params.snrEnable == 0
    % change corresponding text in GUI
    handles.text_numstates_filt.String = [num2str(params.numstates_min),...
        ' → ', num2str(params.numstates_max)];
    handles.text_snr_filt.String = 'any';
    % adjust trace status of parameters are met
    for ii = 1:length(data.rois)
        if ~isempty(data.rois(ii,p.currentChannelIdx).disc_fit)
            n_components = size(data.rois(ii,p.currentChannelIdx).disc_fit.components,1);
            if n_components <= params.numstates_max && ...
                    n_components >= params.numstates_min
                for jj = 1:size(data.rois,2)
                    data.rois(ii,jj).status = 1;
                end
            end
        end
    end
% sort by SNR and # of states
elseif params.numstatesEnable == 1 && params.snrEnable == 1
    % change corresponding text in GUI
    handles.text_snr_filt.String = [num2str(params.snr_min),...
        ' → ', num2str(params.snr_max)];
    computeSNR(0);
    handles.text_numstates_filt.String = [num2str(params.numstates_min),...
        ' → ', num2str(params.numstates_max)];
    % adjust trace status if parameters are met
    for ii = 1:length(data.rois)
        if ~isempty(data.rois(ii,p.currentChannelIdx).disc_fit)
            n_components = size(data.rois(ii,p.currentChannelIdx).disc_fit.components,1);
            trace_snr = data.rois(ii,p.currentChannelIdx).SNR;
            if n_components <= params.numstates_max && ...
                    n_components >= params.numstates_min && ...
                    trace_snr <= params.snr_max && ...
                    trace_snr >= params.snr_min
                for jj = 1:size(data.rois,2)
                    data.rois(ii,jj).status = 1;
                end
            end
        end
    end
end
% redraw titles
goToROI(p.roiIdx);
