function s = ini2struct(filename)
% INI2STRUCT Convert an INI file into a structure

% Read the file
fid = fopen(filename, 'r');
if fid < 0
    error('ini2struct:InvalidFile', 'Unable to open file: %s', filename);
end

% Initialize the structure
s = struct();
crrSection = '';

% Read the file line by line
while ~feof(fid)

    % Read the next line
    line = fgetl(fid);
    if isempty(line) ...
    || line(1) == ';' ...
    || line(1) == '#'
        continue;
    end

    % Check if the line is a section
    if line(1) == '[' ...
    && line(end) == ']'
        crrSection = line(2:end-1);
        s.(crrSection) = struct();
        continue;
    end

    % Check if the line is a key-value pair
    [key, value] = strtok(line, '=');
    if isempty(value)
        continue;
    end
    value = value(2:end);
    value = strrep(value, '\n', newline);
    s.(crrSection).(key) = strtrim(value);
end