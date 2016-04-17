function teardown(net_name, data_name, net_suffix)

if nargin < 3
    net_suffix = '';
end

marvin_root = fullfile('..');

model_name = sprintf('%s_%s', net_name, data_name);
model_full_name = sprintf('%s%s_%s', net_name, net_suffix, data_name);
addpath(fullfile(marvin_root, 'tools', 'tensorIO_matlab'));
model_path = fullfile('models', model_name, [model_full_name, '.json']);
pretrained_path = fullfile('models', model_name, [model_full_name, '_half.marvin']);
if ~exist(fullfile(marvin_root, pretrained_path), 'file')
    error('Download pretrained model %s first', pretrained_path);
end

train_data_path = fullfile(marvin_root, 'data', data_name, 'train_data.tensor');
train_label_path = fullfile(marvin_root, 'data', data_name, 'train_label.tensor');
val_data_path = fullfile(marvin_root, 'data', data_name, 'val_data.tensor');
val_label_path = fullfile(marvin_root, 'data', data_name, 'val_label.tensor');

delete(train_data_path)
delete(train_label_path)
delete(val_data_path)
delete(val_label_path)
delete('cls_prob_0')

end
