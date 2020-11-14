function D = pdist2(X,Y)
D=zeros(size(X,1),size(Y,1));
for(i=1:size(X,1))
    for(j=1:size(Y,1))
        D(i,j)=norm(X(i,:)-Y(j,:));
    end
end
end

