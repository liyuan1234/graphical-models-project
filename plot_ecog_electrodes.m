filename = 'sub-HUP064_ses-presurgery_task-ictal_acq-ecog_run-01_ieeg.edf';
root = './data/hup/sub-HUP064/ses-presurgery/ieeg/';
file = [root filename];
edf_data = edfread(file);
info = edfinfo(file);


%% plot 3d coordinates of ecog electrodes
clc
filename_electrode_coordinates = 'sub-HUP064_ses-presurgery_acq-ecog_space-fsaverage_electrodes.tsv';
file = [root filename_electrode_coordinates];
coordinates = tdfread(file);
name = cellfun(@(x) strrep(x,'EEG ',''),cellstr(coordinates.x0xEF0xBB0xBFname),'UniformOutput',false);
x = coordinates.x;
y = coordinates.y;
z = coordinates.z;

x = chararray2num(x);
y = chararray2num(y);
z = chararray2num(z);

clf;view(3);hold on


nan_coordinates = 1:94;
nan_coordinates(isnan(x)) = [];



% c = repmat([0,0,1],[94,1]);
% c(9:72,:) = repmat([1,0,0],[64,1]);
for i = 1:94
    
    if i >= 9 & i<=72
        c = 'r';
    else
        c = 'b';
    end
plot3(x(i),y(i),z(i),'.','markersize',20,'color',c)
end
text(x(nan_coordinates),y(nan_coordinates),z(nan_coordinates),name(nan_coordinates))

title('electrode coordinates')

saveas(gcf,'electrode_cooridnates.png')

%% local function


function x = chararray2num(x_array)
x_cell = cellstr(x_array);
x = cell(size(x_cell));
for i = 1:length(x_cell)
    
    w = round(str2num(x_cell{i}),3);
    if isempty(w)
        w = nan;
    end
    x{i,1} = w;
    
end


x = cell2mat(x);
end
