function[TrainDensity,NumofCase]=SES(Basefile,NumofRows,TrainDensity)
%TrainDensity¡ª¡ªthe train arrival density in the study,and it's a row
%vector.
%NumofCase¡ª¡ªthe total number of case,and it's a row vector.
%Basefile¡ª¡ªthe name of origin file in the workpath, and it's a string.
%NumofRows¡ª¡ªthe number of rows in the basefile, and it's a number.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This is used to read the basefile.%
file=dir(Basefile);
fid=fopen(file.name,'r','n','UTF-8');
for i=1:NumofRows
    RawData{i}=fgets(fid);
end
%This is used to set the calculated train arrival density range.%
Headway=round(3600./TrainDensity);      %Headway is the arrival time difference between two adjacent trains in the same side tunnel.
NumofCase=round(Headway/10);            %NumofCase is the number of simulation cases used to study the train arrival time interval
                                        %and the increase interval is set to 10s.
%Calculate the First Train Delay time needed in the Route2.%
for j=1:length(TrainDensity)
    for k=1:NumofCase(j)
        TimeInterval(k,j)=1028-(900-Headway(j))+10*(k-1);       %'1028' is the First Train Delay time when the train departure density
    end                                                         % is 4 pairs/h, and train arrival time interval is 0s. '900' is the Headway
end                                                             % when the train departure density is 4 pairs/h.
%This is used to modify the base file and generate%
%simulation files used to simulate different arrival% 
%densities and arrival intervals.%
for m=1:sum(NumofCase)
    for n=1:size(RawData,2)
        SimulationData{m,n}=RawData{1,n};
    end
end
%This is used to modify specific parameters as needed.%
for o=1:length(TrainDensity)
    for p=1:NumofCase(o)
        SimulationData{p+sum(NumofCase(1:o-1)),673}=[' ',num2str(round(TrainDensity(o)*1.5)),'         ',...        %'673' is the row that want to modify.
            '1','         ',num2str(Headway(o)),'       ',10];                                                      %¡®10¡¯is used to creat new line.
        SimulationData{p+sum(NumofCase(1:o-1)),727}=[' ',num2str(round(TrainDensity(o)*1.5)),'         ',...        %'727' is the row that want to modify.
            '1','         ',num2str(Headway(o)),'       ',10];                                                      %¡®10¡¯is used to creat new line.
        if strlength(num2str(TimeInterval(p,o)))==4
            SimulationData{p+sum(NumofCase(1:o-1)),726}=['0.         2         2        ',num2str(TimeInterval(p,o)),...      %'726' is the row that want to modify.
                '.      1        0.         0',10];                                                                           %¡®10¡¯is used to creat new line.
        elseif strlength(num2str(TimeInterval(p,o)))==3
            SimulationData{p+sum(NumofCase(1:o-1)),726}=['0.         2         2        ',num2str(TimeInterval(p,o)),...      %'726' is the row that want to modify.
                '.       1        0.         0',10];                                                                          %¡®10¡¯is used to creat new line.
        end
    end
end
%This is used to output the calculation file.%
for o=1:length(TrainDensity)
    for p=1:NumofCase(o)
        fid=fopen([num2str(TrainDensity(o)),'-',num2str(p),'.ses'],'w+');
        for q=1:size(SimulationData,2)
            fprintf(fid,SimulationData{p+sum(NumofCase(1:o-1)),q});
        end
        fclose(fid);
    end
end
