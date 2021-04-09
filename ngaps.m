sd=rand(1028,1);
beg=sort(randi(length(sd),1,2*num));
sd(matranges(beg))=NaN;
plot(sd)

for index=1:num-1
%  C{index}=sd( beg,index : beg,index )
end

difer(sum(abs(sd(~isnan(sd))))-sum(abs(cat(1,C{:}))))
