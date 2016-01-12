function output=toAbsPath(pathStr)
% toAbsPath: Convert a path string to an absolute path
%	Usage: output=toAbsPath(pathStr)
%
%	For example:
%		absPath=toAbsPath('myWork\code')

%	Roger Jang, 20080606, 20140821

if strcmp(pathStr, '.')|strcmp(pathStr, './')
	output=pwd;
	return
end

if strcmp(pathStr, '..')|strcmp(pathStr, '../')
	output=fileparts(pwd);
	return
end

output=pathStr;
if ~isAbsPath(pathStr)
	output=[pwd, '\', pathStr];
end