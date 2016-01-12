%gmmTrainDemo1d: Example of using GMM (gaussian mixture model) for 1-D data
%
%	Usage:
%		gmmTrainDemo1d
%
%	Description:
%		gmmTrainDemo1d demonstrates the use of GMM for 1-D data.
%
%	Example:
%		gmmTrainDemo1d

%	Category: GMM
%	Roger Jang, 20080304

% ====== �e�X��ƽ��ϡ]Histogram�^
DS = dcData(8); data = DS.input;
subplot(2,1,1);
binNum = 30;
hist(data, binNum);
xlabel('Data values'); ylabel('Counts'); title('Data histogram');
colormap(summer);
% ====== Perform GMM training (�i�� GMM �V�m)
opt=gmmTrain('defaultOpt');
opt.config.gaussianNum=3;
[gmmPrm, lp]=gmmTrain(data, opt);
% ====== Plot log likelihood as the function of iterations (�e�X log likelihood �b�V�m�L�{���ܤ�)
subplot(2,1,2);
plot(lp, 'o-');
xlabel('No. of iterations of GMM training');
ylabel('Log probability');
% ====== �L�X�V�m���G
fprintf('w1=%g, mu1=%g, v1=%g\n', gmmPrm(1).w, gmmPrm(1).mu, gmmPrm(1).sigma);
fprintf('w2=%g, mu2=%g, v2=%g\n', gmmPrm(2).w, gmmPrm(2).mu, gmmPrm(2).sigma);
fprintf('w3=%g, mu3=%g, v3=%g\n', gmmPrm(3).w, gmmPrm(3).mu, gmmPrm(3).sigma);
fprintf('Overall logProb = %g\n', sum(log(gmmEval(data, gmmPrm))));

figure
% ====== Plot histogram (�e�X��ƽ���)
subplot(2,1,1);
binNum = 30;
hist(data, binNum);
xlabel('Data values'); ylabel('Counts'); title('Data histogram');
colormap(summer);
bound = axis;
x = linspace(bound(1), bound(2));
% ====== Plot the Gaussian PDF (�e�X Gaussian �����v�K�ר��)
subplot(2,1,2);
hold on
for i = 1:opt.config.gaussianNum,
	h1 = plot(x, gaussian(x, gmmPrm(i)), '--m');
	set(h1, 'linewidth', 2);
end
for i = 1:opt.config.gaussianNum,
	h2 = plot(x, gaussian(x, gmmPrm(i))*gmmPrm(i).w, ':b');
	set(h2, 'linewidth', 2);
end
total = zeros(size(x));
for i = 1:opt.config.gaussianNum,
	g(i,:)=gaussian(x, gmmPrm(i));
	total=total+g(i, :)*gmmPrm(i).w;
end
h3 = plot(x, total, 'r');
set(h3, 'linewidth', 2);
hold off
box on
legend([h1 h2 h3], 'g_i', 'w_ig_i', '\Sigma_i w_ig_i');
xlabel('Data values'); ylabel('Prob.'); title('Gaussian mixture model');
% ���W g1, g2, g3
for i=1:opt.config.gaussianNum
	[maxValue, index]=max(g(i, :));
	text(x(index), maxValue, ['g_', int2str(i)], 'vertical', 'bottom', 'horizon', 'center');
end
% ====== Plot the scaled PDF on top of the histogram (�e�X�|�[�� histogram �����u)
k = size(data,2)*(max(data)-min(data))/binNum;
subplot(2,1,1)
line(x, total*k, 'color', 'r', 'linewidth', 2);