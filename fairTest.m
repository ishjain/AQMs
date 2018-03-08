%fairTest.m

%get fairness result from my2code/DataDir and plot them

clear all;
close all;
files = {'mainfile1fair.csv','mainfile10fair.csv','mainfile100fair.csv'};
figureDir = 'Matlab results';
list = {'ared', 'fq\_co','fq\_noco', 'cod', 'pie', 'pfifo\_f', 'sfq'};
list2 = {'pf\_f','ared','pie','cod','sfq','fq\_noc','fq\_c'};
spacing=[25,0.3;10,0.01;.2,0.3];
for i=1:3
    data1 = csvread(files{i},1,0);
    
    if (i==1)
        data1=data1/1000;
    end
    % for i=1:5
    
    for j=1:7
        data1j(j,:) = mean(data1(j:7:end,:));
        data1jmax(j,:) = max(data1(j:7:end,:));
        data1jmin(j,:) = min(data1(j:7:end,:));
    end
    idx = [6,1,5,4,7,3,2];
    
    
    data1j=data1j(idx,:);
    
    findex(:,i) = (sum(data1j,2)).^2./3./sum(data1j.^2,2);
    figure(i);
    bar(data1j,1);grid on;
    legend('10ms','50ms','200ms')
    set(gca,'fontsize',17)
    set(gca,'XTick',1:7,'XTickLabel',list2)
    % hold on
    % errorbar(data1j,y1min,y1max,'ok')
    
    %%
    
    xlabel('Mean induced latency (ms)')
    ylabel('Mean bandwidth (Mbits/sec)')
    
    
    
end
% figure(1)
% title('10/1 Mbps link speed, both direction shown')
% saveas(gcf,'rrulLink1.eps'),'epsc'
% saveas(gcf, 'rrulLink1.png')
figure(1)
% title('10/1 Mbps link speed (10ms, 50ms, 200ms bar graph)', 'fontsize',12)
ylim([0,.6])
saveas(gcf,fullfile(figureDir,'rrulLink1fair.eps'),'epsc')
saveas(gcf, fullfile(figureDir,'rrulLink1fair.png'))

figure(2)
% title('10/10 Mbps link speed (10ms, 50ms, 200ms bar graph)', 'fontsize',12)

ylim([0,6])
saveas(gcf,fullfile(figureDir,'rrulLink10fair.eps'),'epsc')
saveas(gcf, fullfile(figureDir,'rrulLink10fair.png'))
figure(3)
% title('100/100 Mbps link speed (10ms, 50ms, 200ms bar graph)')
ylim([0,60])
saveas(gcf,fullfile(figureDir,'rrulLink100fair.eps'),'epsc')
saveas(gcf, fullfile(figureDir,'rrulLink100fair.png'))

figure(4);
fair_handle=bar(findex',1);grid on;
ylim([0,1.2])
set(gca,'XTick',1:3,'XTickLabel',{'100Mbit','10Mbit','1Mbit'} )
legend({'pfifo\_fast','ared','pie','codel','sfq','fq\_nocodel','fq\_codel'},'Location','northwestoutside')
set(gca,'fontsize',14)
ylabel('Fairness Index')

% figure;
% subplot(1,3,1)
% bar(findex(:,3))
% set(gca,'XTick',1:7,'XTickLabel',list2)
% ylim([0,1.2])
% title('100Mbit')
%
% subplot(1,3,2)
% bar(findex(:,2))
% set(gca,'XTick',1:7,'XTickLabel',list2)
% ylim([0,1.2])
% title('10Mbit')
%
% subplot(1,3,3)
% bar(findex(:,1))
% set(gca,'XTick',1:7,'XTickLabel',list2)
% ylim([0,1.2])
% title('1Mbit')

saveas(gcf,fullfile(figureDir,'fairness2.eps'),'epsc')
saveas(gcf, fullfile(figureDir,'fairness2.png'))