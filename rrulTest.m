%rrulTest.m

%Take data from DataDir (only mainfile1,mainfile10, and mainfile100 are required )
clear all;
close all;
files = {'mainfile1.csv','mainfile10.csv','mainfile100.csv'};

figureDir = 'Matlab results';
spacing=[25,0.4;10,0.06;12,0.4];
for i=1:3
data1 = csvread(files{i},1,0);
list = {'ared', 'fq\_co','fq\_no', 'codel', 'pie', 'pf\_fast', 'sfq'};
% for i=1:5
figure(i);hold on;grid on;
for j=1:7
    data1j(j,:) = mean(data1(j:7:end,:));
    data1jmax(j,:) = max(data1(j:7:end,:));
    data1jmin(j,:) = min(data1(j:7:end,:));
    xall(:,j) = data1(j:7:end,1)-50;
    yall(:,j) = data1(j:7:end,4);
    y_for1(:,j) = data1(j:7:end,5);
    C = cov(xall(:,j),yall(:,j));
    mu = [mean(xall(:,j)),mean(yall(:,j))];
    h(j) = error_ellipse(C,mu);
    scatter(mu(1),mu(2),'*');
%     set(h(j),'color',)
end
%%
x1=data1j(:,1)-50;
tm1 = data1jmax(:,1)-50;
tm2 = data1jmin(:,1)-50;
x1max = -x1+tm1;
x1min = x1-tm1;

y1=data1j(:,4);
y1max = -y1+data1jmax(:,4);
y1min = y1-data1jmin(:,4);

y11=data1j(:,5);
y11max = -y11+data1jmax(:,5);
y11min = y11-data1jmin(:,5);
figure(i);
% errorbar(x1,y1,y1min,y1max,'o')%,x1min,x1max) ;
t=text(x1+spacing(i,1),y1+spacing(i,2),list);
set(t,'fontsize',14)
set (gca,'xdir','reverse','fontsize',14)

xlabel('Mean induced latency (ms)')
ylabel('Mean TCP goodput (Mbits/sec)')

if(i==1)
hold on;
errorbar(x1,y11,y11min,y11max,'d')
end


end
figure(1); 
xlim([0,350])
% title('10/1 Mbps link speed, both direction shown')
saveas(gcf,fullfile(figureDir,'rrulLink1.eps'))
saveas(gcf, fullfile(figureDir,'rrulLink1.png'))

figure(2)
% title('10/10 Mbps link speed, both direction shown')
ylim([8.6,9.4])
saveas(gcf,fullfile(figureDir,'rrulLink10.eps'))
saveas(gcf, fullfile(figureDir,'rrulLink10.png'))

figure(3)
xlim([0,80]);
% title('100/100 Mbps link speed, both direction shown')
saveas(gcf,fullfile(figureDir,'rrulLink100.eps'))
saveas(gcf, fullfile(figureDir,'rrulLink100.png'))