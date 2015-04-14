function [straightIndex, leftIndex, rightIndex] = getTurnIndex(turnlogg)
j=1;
k=1;
l=1;
leftIndex=zeros(length(turnlogg));
rightIndex=zeros(length(turnlogg));
straightIndex=zeros(length(turnlogg));


    for i=1:length(turnlogg)
        if turnlogg(i)==0
            straightIndex(j)=i;
            j=j+1;
        elseif turnlogg(i)==1
            leftIndex(k)=i;
            k=k+1;
        elseif turnlogg(i)==0.9
            rightIndex(l)=i;
            l=l+1;
        end
    end
leftIndex=leftIndex(1:k-1);
rightIndex=rightIndex(1:l-1);
straightIndex=straightIndex(1:j-1);
end

