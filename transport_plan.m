
clear;clc;

eps=1e-6;% С��eps��Cֱ������
m=10;% ��������
n=15;% �ֿ����m < n

pos=unidrnd(100,m+n,2);%����m+n��λ��(x,y)
pos1=pos(1:m,:);
pos2=pos(m+1:m+n,:);

vol2=unidrnd(30,1,n);%����n���ֿ������
vol1 = fliplr(vol2(1:m));%��vol2�õ�vol1
vol1(1:n-m) = vol1(1:n-m) + vol2(m+1:end);
%����������ֿ�����
figure(1);
hold on
plot(vol1);
plot(vol2);
legend('production','storage');
title('Volume');
hold off

distance=zeros(m,n);
for i=1:m %����ÿ��������ÿ���ֿ�ľ���
    for j=1:n
        distance(i,j)=norm( pos1(i,:)-pos2(j,:) );
    end
end

%�Ż�
cvx_begin
    variable C(m,n)
    minimize(sum(sum(C.*distance)))
    
    subject to 
        sum(C,1)==vol2
        sum(C,2)==vol1'
        C>=0
cvx_end

C(C<eps)=0;% С��eps��Cֱ������

figure(2);
hold on
axis([-10 110 -10 110]);
scatter(pos1(:,1),pos1(:,2),'+r');%�������꣬��'+'��ʾ
scatter(pos2(:,1),pos2(:,2),'sb');%�ֿ����꣬��'��'��ʾ
title('location');
legend('\factory','warehouse');

%�����Ż������������ͼ
for i_fac=1:m
    x1=pos1(i_fac,1);
    y1=pos1(i_fac,2);
    house_list=find(C(i_fac,:));

    for i_house = house_list
        plot([x1 pos2(i_house,1)],[y1 pos2(i_house,2)]);
        text(mean([x1 pos2(i_house,1)]),mean([y1 pos2(i_house,2)]),...
            num2str(C(i_fac,i_house)));
    end
end
hold off
