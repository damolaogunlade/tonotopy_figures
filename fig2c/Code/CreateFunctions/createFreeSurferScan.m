function [scan] = createFreeSurferScan(boldPath, roiPath,fsid, roiCoords)
% [scan] = createFreeSurferScan(boldPath, roiPath)
%
% Helpful function to createScan.m. Extracts the scan information from
% FreeSurfer .nii, .nii.gz, .mgz files (boldPath) within a given .label
% ROI.
%
% Inputs: 
%   boldPath            Path to BOLD information (.nii, .nii.gz, .mgz), 
%                       string
%   roiPath             Path to ROI information (.label), if empty string, 
%                       will extract full brain time courses, string.
% Output:
%   scan                A structure containing the provided scan 
%                       infromation as fields:
%       boldFile        Name of the BOLD data file (.nii, .nii.gz, .mgz), 
%                       string
%       boldSize        Size of the BOLD data in [nVolumes x y z] format, 
%                       numeric
%       nVols           Number of volumes, numeric
%       TR              Scan TR, seconds
%       dur             Total scan duration, seconds
%       t               Time vector of the scan in TRs, seconds
%       voxID           Voxel index number, numeric
%       vtc             Voxel time course in [nVolumes nVox] format,
%                       numeric
%
% Note:
% - Dependencies: <a href="matlab: web('https://github.com/vistalab/vistasoft/tree/master/external/freesurfer')">mrVista/FreeSurfer</a>

% Written by Kelly Chang - July 19, 2017

%% Extract Scan Information from .nii, .nii.gz, .mgz (and .label)

bold = MRIread(boldPath); % load .nii file
tc = squeeze(bold.vol);
tc = permute(tc, [ndims(tc) 1:(ndims(tc)-1)]); % bold time course
scan.boldSize = size(tc); % size of the bold data
tc = reshape(tc, size(tc,1), []);

if ~all(cellfun(@isempty, roiPath))
    vertices = [];
    for i = 1:length(roiPath)
        % The line below doesn't seem accurate, should be using
        % freesurfer's read_label matlab function. The thing below doesn't
        % return the actual number of vertices in a .label file...
        %vertices = [vertices readLabels(roiPath{i})']; % read .lable file, zero-based indexing
        [~,lblname,~] = fileparts(roiPath{i}); 
        if exist('roiCoords','var') % if using volumetric roi, replace l(1) with integer array and l(2,3,4) with roiCoords 
            l = zeros(length(roiCoords),5);
            l(:,1) = 1:length(l);
            l(:,2:4) = roiCoords;
        else
         % If using surface label, use read_label 
         [l, coords] = read_label(fsid, lblname);
        end
        vertices = [vertices l(:,1)'];
    end
    else
    vertices = 0:(size(tc,1)-1); % select all vertices
end

[~,file,ext] = fileparts(boldPath);
scan.boldFile = [file ext]; % name of bold data file
scan.nVols = bold.nframes; % number of volumes in the scan
scan.TR = bold.tr/1000; % seconds
scan.dur = scan.nVols*scan.TR; % scan duration, seconds
scan.t = 0:scan.TR:(scan.dur-scan.TR); % time vector, seconds
scan.voxID = vertices; % vertices, zero-based indexing
scan.vtc = tc(:,vertices+1); % extract time course of vertices, +1 to zero-based indexing