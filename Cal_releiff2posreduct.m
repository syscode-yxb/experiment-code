function [overalltime,red ] = Cal_releiff2posreduct( data,parameter,threshold)
% Such function is FARA stategy
overall_time_start=tic;
time=[];
[m,n]=size(data);
for i=1:n-1
    condition1 = Cal_condition( data(:,i),parameter );
    singlegran(1,i)=sum(sum(condition1))/m; 
end


time1_start=tic;
[ relation ] = Cal_condition( data(:,1:end-1),parameter );
time1=toc(time1_start);
time=[time,time1];
rawgran(1,i)=sum(sum(relation))/m;
ranked=singlegran./rawgran; 

[decisionclass] = Cal_decision(data(:,end));
[Low] = Cal_low(relation,decisionclass);
rawpos=sum(max(Low));

red=zeros(1,n-1);

k=1;

tmppos=-1000;
Low=zeros(1,m);
while k<=n-1
    if tmppos>=threshold*rawpos
        break
    else
    tmpSig=-9000.*ones(1,n-1);
    tmptmpLow=zeros(n-1,m);
    if k==1 
        [decisionclass] = Cal_decision(data(:,end));
        for j=1:n-1 
            if  red(1,j)==0
                red(1,j)=1;
                tmpdata=data(:,red==1);  
                [ relation ] = Cal_condition( tmpdata,parameter );
                clear tmpdata
                [tmpLow] = Cal_low(relation,decisionclass);
                tmptmpLow(j,:)=max(tmpLow);
                tmpSig(1,j)=sum(max(tmpLow));
                red(1,j)=0;
            end  
        end
    else

       cc=ranked<=ranked(1,x);
       [decisionclass] = Cal_decision(data(:,end));
       if sum(cc)>0
          for j=1:n-1 
              if  red(1,j)==0 & cc(j)==1
              red(1,j)=1;
               tmpdata=data(:,red==1);  
               [ relation ] = Cal_condition(tmpdata,parameter );
               clear tmpdata              
               [tmpLow] = Cal_low(relation,decisionclass);
               tmptmpLow(j,:)=max(tmpLow);
               tmpSig(1,j)=sum(max(tmpLow));
               red(1,j)=0;
              end  
           end
       else
           for j=1:n-1 
              if  red(1,j)==0 
                  red(1,j)=1;
                  tmpdata=data(:,red==1);  
                  [ relation ] = Cal_condition(tmpdata,parameter );
                  clear tmpdata
                  [tmpLow] = Cal_low(relation,decisionclass);
                  tmptmpLow(j,:)=max(tmpLow);
                  tmpSig(1,j)=sum(max(tmpLow));
                  red(1,j)=0;
              end  
           end
       end
    end
        [~,x]=max(tmpSig);   
        red(1,x)=1;
        k=k+1; 
        cc1=zeros(1,n-1);
        for j=1:n-1
            if red(1,j)==0 & max(tmptmpLow(j,:)-tmptmpLow(x,:))==1
                tmp=tmptmpLow(j,:)-tmptmpLow(x,:);
                tmp=tmp==1;
                cc1(1,j)=sum(tmp);
            end
        end
        [value,position]=max(cc1);
        if value~=0
            red(1,position)=1;
        end
        tmpdata=data(:,red==1);   
        [ relation ] = Cal_condition(tmpdata,parameter);
        [decisionclass] = Cal_decision(data(:,end));
        [tmpLow] = Cal_low(relation,decisionclass);
        tmppos=sum(max(tmpLow));
    end
end
overalltime=toc(overall_time_start)-sum(time);

% redpos=tmppos;
% if sum(red)>=2
%     for j=1:n-1
%         if sum(red)==1
%             break 
%         else
%             if  red(1,j)==1
%                 red(1,j)=0;
%                 tmpdata=data(:,red==1);
%                 [tmprelation] = Cal_condition( tmpdata,parameter );
%                 [tmpLow] = Cal_low(tmprelation,decisionclass);
%                 tmppos = sum(max(tmpLow));
%                 if tmppos<threshold*redpos
%                     red(1,j)=1;
%                 end
%             end
%         end
%     end
% end

end

