function[ResultsName,ResultsData]=ResultsAnalysis(NumofRows,Time)
%NumofRows！！the maximum number of rows in the results files, and it's a number.
%Time！！the simulation time of SES files.
%ResultsName！！a variable stores the results information.
%ResultsData！！a variable stores the results used to futher analyze.
clc
file=dir('*.prn');
k=1;m=1;
ResultsName=strings;
for i=1:2%length(file)
    fid=fopen(file(i).name,'r','n','UTF-8');
    ResultsName(i)=file(i).name;
    for j=1:NumofRows
        RawData=fgets(fid);
        if regexp(RawData,'^          33 - 33 -  1')==1        %Use regular expressions to extract the specified row.'^' represents the starting value of a line.
            RawData=strsplit(RawData,' ');
            ResultsData(k,1,i)=str2num(cell2mat((RawData(9))));%This is used to extract the specified column.
            k=k+1;
        elseif regexp(RawData,'^          43 - 43 -  1')==1    %Use regular expressions to extract the specified row.'^' represents the starting value of a line.
            RawData=strsplit(RawData,' ');
            ResultsData(m,2,i)=str2num(cell2mat((RawData(9))));%This is used to extract the specified column.
            m=m+1;
        end
        if m==Time+2                                           %This is used to determine if all the required data has been extracted.
            k=1;m=1;clear RawData;fclose(fid);break
        end
    end
end