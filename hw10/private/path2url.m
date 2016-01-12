function url=path2url(pathStr, opt)
% toAbsPath: Convert a disk path to an URL address
%
%	Usage:
%		url=path2url(pathStr)
%
%	Example:
%		url=path2url(which('qcTrain'));
%		web(url);

%	Roger Jang, 20140821

if nargin<1, selfdemo; return; end
% ====== Set the default options
if nargin==1 && ischar(pathStr) && strcmpi(pathStr, 'defaultOpt')
	url.host='';		% 'mirlab.org', 'localhost', or []
	return
end
if nargin<2|isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
%if nargin<3, showPlot=0; end

absPath=toAbsPath(pathStr);
absPath=strrep(absPath, '\', '/');

url=absPath;
if isempty(opt.host)
	url=regexprep(url, '^d:/users/jang', '/jang', 'ignorecase');
	url=regexprep(url, '^/users/jang', '/jang', 'ignorecase');
	url=regexprep(url, '^d:/dataSet', '/dataSet', 'ignorecase');
	url=regexprep(url, '^/dataSet', '/dataSet', 'ignorecase');
else
	url=regexprep(url, '^d:/users/jang', ['http://', opt.host, '/jang'], 'ignorecase');
	url=regexprep(url, '^/users/jang', ['http://', opt.host, '/jang'], 'ignorecase');
	url=regexprep(url, '^d:/dataSet', ['http://', opt.host, '/dataSet'], 'ignorecase');
	url=regexprep(url, '^/dataSet', ['http://', opt.host, '/dataSet'], 'ignorecase');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);