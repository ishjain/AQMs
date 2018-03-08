%transiTest.m

%Test for transient analysis.

%Use data from parameter1, parameter10, parameter100 directory
%for 1/10, 10/10, 100/100 mbps links
%The file names are like "filename-ared,-1,.csv"
%Data starts from 5th row and avg latency is at 8th column
%Remember to substract 50 from latency value. (We had set 50ms base rtt value)

clear all
close all
Datadir = 'E:\google drive\3 sem NYU\EL7353 Network Modelling\Project-ikj211\DataDir_Trans_Dec18';
folders = {'parameter1','parameter10','parameter100'};
list = {'ared', 'fq_codel','fq_nocodel', 'codel', 'pie', 'pfifo_fast', 'sfq'};
list2 = {'pfifo\_fast','ared','pie','codel','sfq','fq\_nocodel','fq\_codel'};
for i = 1:3
    for j=2:7
        for k=1:5%iteration
            filename = strcat('filename-',list{j},',-',num2str(k),',.csv');
            data= csvread(fullfile(Datadir,folders{i},filename),1,0 );%,10,8,[10,8,11,8]);
            x1(:,k)=data(:,1);
            y1(:,k)=data(:,8);
            
        end
        x(:,j)=mean(x1,2);
        y(:,j)=mean(y1,2);
 
    end
        idx = [6,1,5,4,7,3,2];
    
    
    x=x(:,idx);
    y=y(:,idx);
           figure(i); hold on; grid on;
           for j=1:7
        plot(x(1:125,j),y(1:125,j)-50,'linewidth',2)
           end
        xlabel('Time(s)')
        ylabel('Latency(ms)')
        set(gca,'fontsize',17)
        legend(list2)
end
figureDir = 'Matlab results';
figure(1)
title('10/1')
ylim([0,1100])
saveas(gcf,fullfile(figureDir,'transiTest1.eps'))
saveas(gcf, fullfile(figureDir,'transiTest1.png'))

figure(2)
title('10/10')
ylim([0,400])
saveas(gcf,fullfile(figureDir,'transiTest10.eps'))
saveas(gcf, fullfile(figureDir,'transiTest10.png'))

figure(3)
title('100/100')
saveas(gcf,fullfile(figureDir,'transiTest100.eps'))
saveas(gcf, fullfile(figureDir,'transiTest100.png'))