clear;
close all;
[img1 map1 alpha1]= imread('0621_1.png');
%figure, imshow(alpha1)
[img2 map2 alpha2] = imread('0621_2.png');
%figure, imshow(alpha2)
%imshow(A)
alpha_one=alpha1;
alpha_two=alpha2;
skinarray1=zeros(800,3);
skinarray2=zeros(800,3);

count=1;
 for row=1:size(img1,1)
    for co1=1:size(img1,2)
       if  alpha_one(row,co1,:) ~= 0
           count=count+1;
           skinarray1(count,:)=img1(row,co1,:);
       end   
    end;
end;
 
count1=1;
 for row=1:size(img2,1)
    for co1=1:size(img2,2)
       if alpha_two(row,co1,:) ~= 0
           count1=count1+1;
           skinarray2(count1,:)=img2(row,co1,:);
       end   
    end;
end;
skin_sum=[skinarray1;skinarray2];%將膚色存進skin_sum的陣列
train_img =rgb2ycbcr(skin_sum);%膚色陣列轉YCBCR
Y_range=(max(train_img(:,1))-min(train_img(:,1)))/3;

k=3;
train_img_max=max(train_img(:,1));%算出Y群的最大值
train_img_min=min(train_img(:,1));%算出Y群的最小值
train_img_average=(max(train_img(:,1))-min(train_img(:,1)))/k;%算出Y群的平均

clear range;
for i=1:1:k+1
   range(i,1)= train_img_min+(i-1)*train_img_average;%算出分三區的範圍
end
%test=train_img_min+(4-1)*train_img_average
% range =
% [0.0627
% 59.8019
% 119.5411
% 179.2803]


clear Y1_idx Y1 Y2_idx Y2 Y3_idx Y3 Cen;
i=1;
Y1_idx = train_img(:, 1) >= range(i) & train_img(:, 1) < range(i+1);%有分進的話是1沒分進是0
Y1 = train_img(Y1_idx, :);%分三區塊中的第一區塊
i=2;
Y2_idx = train_img(:, 1) >= range(i) & train_img(:, 1) < range(i+1);
Y2 = train_img(Y2_idx, :);%分三區塊中的第二區塊
i=3;
Y3_idx = train_img(:, 1) >= range(i) & train_img(:, 1) <= range(i+1);
Y3 = train_img(Y3_idx, :);%分三區塊中的第三區塊
iter(Y1_idx) = i;
iter(Y2_idx) = i;
iter(Y3_idx) = i;

for count=1:15
%算中心點
i=1;
Cen(i,1) = sum(Y1(:,1))/size(Y1,1);
Cen(i,2) = sum(Y1(:,2))/size(Y1,1);
Cen(i,3) = sum(Y1(:,3))/size(Y1,1);


%算質中心距離第三公式
C_sum=0;
 for t=1:size(Y1,1)
    C_sum=C_sum+((Y1(t,:)-Cen(1,:))*(Y1(t,:)-Cen(1,:))'); %1x3矩陣轉3x1矩陣=1x1的值
 end
C(1)=C_sum/(size(Y1,1)-1);
%C_one=C_sum/(size(Y1,1)-1);

%算中心點
i=2;
Cen(i,1) = sum(Y2(:,1))/size(Y2,1);
Cen(i,2) = sum(Y2(:,2))/size(Y2,1);
Cen(i,3) = sum(Y2(:,3))/size(Y2,1);
%算質中心距離第三公式
C_sum=0;
 for t=1:size(Y2,1)
    C_sum=C_sum+((Y2(t,:)-Cen(2,:))*(Y2(t,:)-Cen(2,:))');
 end
C(2)=C_sum/(size(Y2,1)-1);
%C_two=C_sum/(size(Y2,1)-1);



%算中心點
i=3;
Cen(i,1) = sum(Y3(:,1))/size(Y3,1);
Cen(i,2) = sum(Y3(:,2))/size(Y3,1);
Cen(i,3) = sum(Y3(:,3))/size(Y3,1);
%算質中心距離第三公式
C_sum=0;
 for t=1:size(Y3,1)
    C_sum=C_sum+((Y3(t,:)-Cen(3,:))*(Y3(t,:)-Cen(3,:))');
 end
C(3)=C_sum/(size(Y3,1)-1);
%C_three=C_sum/(size(Y3,1)-1);


New_Y1=zeros(3,3);New_Y2=zeros(3,3);New_Y3=zeros(3,3);
count_1=0;count_2=0;count_3=0;
%Y =[Y3;Y2;Y1];
 
%for i=1:size(,1)
%     for k=1:3
%     N(k)=(((Y(i,:)-Cen(k,:))')*inv(C(k)))*(Y(i,:)-Cen(k,:));
%     end
clear New_M
New_M=zeros(1,3);

for i=1:size(Y1,1)
    M_1 =((Y1(i,:)-Cen(1,:))*inv(C(1)))*(Y1(i,:)-Cen(1,:))';%算群距離
    M_2 =((Y1(i,:)-Cen(2,:))*inv(C(2)))*(Y1(i,:)-Cen(2,:))';
    M_3 =((Y1(i,:)-Cen(3,:))*inv(C(3)))*(Y1(i,:)-Cen(3,:))';
%     M_1_min=min(M_1);
%     M_2_min=min(M_2);
%     M_3_min=min(M_3);
    if  M_1  < M_2 && M_1 < M_3
        count_1=count_1+1;
        New_Y1(count_1,:)= Y1(i,:);
        New_M(count_1,1)=M_1;
    end
    if  M_2 < M_1&& M_2 < M_3
        count_2=count_2+1;
        New_Y2(count_2,:)= Y1(i,:);
        New_M(count_2,2)=M_2;
    end
    if  M_3 < M_1 && M_3 < M_2
        count_3=count_3+1;
        New_Y3(count_3,:)= Y1(i,:);
        New_M(count_3,3)=M_3;
    end
end    
% 
% New_Y1=zeros(3,3);New_Y2=zeros(3,3);New_Y3=zeros(3,3);
% count_1=0;count_2=0;count_3=0;
for i=1:size(Y2,1)
    M_1 =(Y2(i,:)-Cen(1,:))*inv(C(1))*(Y2(i,:)-Cen(1,:))';
    M_2 =(Y2(i,:)-Cen(2,:))*inv(C(2))*(Y2(i,:)-Cen(2,:))';
    M_3 =(Y2(i,:)-Cen(3,:))*inv(C(3))*(Y2(i,:)-Cen(3,:))';
%     M_1_min=min(M_1);
%     M_2_min=min(M_2);
%     M_3_min=min(M_3);
    if  M_1 < M_2 && M_1 < M_3
        count_1=count_1+1;
        New_Y1(count_1,:)= Y2(i,:);
        New_M(count_1,1)=M_1;
    end
    if  M_2 < M_1 && M_2 < M_3
        count_2=count_2+1;
        New_Y2(count_2,:)= Y2(i,:);
        New_M(count_2,2)=M_2;
    end
    if  M_3 < M_1&& M_3 < M_2
        count_3=count_3+1;
        New_Y3(count_3,:)= Y2(i,:);
        New_M(count_3,3)=M_3;
    end
end    
   
% New_Y1=zeros(3,3);New_Y2=zeros(3,3);New_Y3=zeros(3,3);
% count_1=0;count_2=0;count_3=0;
for i=1:size(Y3,1)
    
    M_1 =((Y3(i,:)-Cen(1,:))*inv(C(1)))*(Y3(i,:)-Cen(1,:))';
    M_2 =((Y3(i,:)-Cen(2,:))*inv(C(2)))*(Y3(i,:)-Cen(2,:))';
    M_3 =((Y3(i,:)-Cen(3,:))*inv(C(3)))*(Y3(i,:)-Cen(3,:))';
  
    if  M_1 < M_2 && M_1 < M_3
        count_1=count_1+1;
        New_Y1(count_1,:)= Y3(i,:);
        New_M(count_1,1)=M_1;
    end
    if  M_2 < M_1 && M_2 < M_3
        count_2=count_2+1;
        New_Y2(count_2,:)= Y3(i,:);
        New_M(count_2,2)=M_2;
    end
    if  M_3< M_1 && M_3< M_2
        count_3=count_3+1;
        New_Y3(count_3,:)= Y3(i,:);
        New_M(count_3,3)=M_3;
    end
end    

Y1=New_Y1;
Y2=New_Y2;
Y3=New_Y3;
iter(Y1_idx) = i;
iter(Y2_idx) = i;
iter(Y3_idx) = i;
disp([num2str(count) '：']);
disp(['New_Y1: ' num2str(size(New_Y1,1))]);
disp(['New_Y2: ' num2str(size(New_Y2,1))]);
disp(['New_Y3: ' num2str(size(New_Y3,1))]);
%end
%     if  M_1_min < M_2_min & M_1_min < M_3_min
%         count_1=count_1+1;
%         New_Y1(count_1,:)= Y(i,:);
%     end
%     if  M_2_min < M_1_min & M_2_min < M_3_min
%         count_2=count_2+1;
%         New_Y2(count_2,:)= Y(i,:);
%     end
%     if  M_3_min < M_1_min & M_3_min < M_2_min
%         count_3=count_3+1;
%         New_Y2(count_3,:)= Y(i,:);
%     end
       
%end

% tic
% % Y1=zeros(100,3);Y2=zeros(100,3);Y3=zeros(100,3);
% clear Y1_idx Y1 Y2_idx Y2 Y3_idx Y3;
% count=[1 1 1];
% for i=1:size(train_img, 1)
%     temp =train_img(i, 1);
%     if (temp <= train_img_min+train_img_average && temp >= train_img_min)
%         Y1(count(1), :)=train_img(i, :);
%         count(1) = count(1)+1;
%     elseif(temp > train_img_min+train_img_average && temp <= train_img_min+train_img_average*2)
%         Y2(count(2), :)=train_img(i, :);
%         count(2) = count(2)+1;
%     elseif(temp > train_img_min+train_img_average*2 && temp <=train_img_max)
%         Y3(count(3), :)=train_img(i, :);
%         count(3) = count(3)+1;
%     end

%算質中心距離第三公式

%算中心點
i=1;
New_Cen(i,1) = sum(New_Y1(:,1))/size(New_Y1,1);
New_Cen(i,2) = sum(New_Y1(:,2))/size(New_Y1,1);
New_Cen(i,3) = sum(New_Y1(:,3))/size(New_Y1,1);
C_sum=0;
 for t=1:size(New_Y1,1)
    C_sum=C_sum+((New_Y1(t,:)-New_Cen(1,:))*(New_Y1(t,:)-New_Cen(1,:))'); %1x3矩陣轉3x1矩陣=1x1的值
 end
New_C(1)=C_sum/(size(New_Y1,1)-1);

i=2;
New_Cen(i,1) = sum(New_Y2(:,1))/size(New_Y2,1);
New_Cen(i,2) = sum(New_Y2(:,2))/size(New_Y2,1);
New_Cen(i,3) = sum(New_Y2(:,3))/size(New_Y2,1);
C_sum=0;
 for t=1:size(New_Y2,1)
    C_sum=C_sum+((New_Y2(t,:)-New_Cen(1,:))*(New_Y2(t,:)-New_Cen(2,:))'); %1x3矩陣轉3x1矩陣=1x1的值
 end
New_C(2)=C_sum/(size(New_Y2,1)-1);

i=3;
New_Cen(i,1) = sum(New_Y3(:,1))/size(New_Y3,1);
New_Cen(i,2) = sum(New_Y3(:,2))/size(New_Y3,1);
New_Cen(i,3) = sum(New_Y3(:,3))/size(New_Y3,1);
C_sum=0;
 for t=1:size(New_Y3,1)
    C_sum=C_sum+((New_Y3(t,:)-New_Cen(1,:))*(New_Y3(t,:)-New_Cen(3,:))'); %1x3矩陣轉3x1矩陣=1x1的值
 end
New_C(3)=C_sum/(size(New_Y3,1)-1);


 end;
 
%  test_img =rgb2ycbcr(imread(dirs));
%  cross=strrep(dirs,'.jpg','.ppm');
%  cross_img=imread(cross);
%      
%      
%  figure;
%  g1=(test_img(:,:,2)<135 & test_img(:,:,2)>75) &( test_img(:,:,3)<180 & test_img(:,:,3)>130) ;%PAPER中的第一階段，快速篩選
%  imshow(g1,[]),title('第一階段篩選 binary pic');
% disp('end')
% toc

figure
scatter3(Y1(:,3),Y1(:,2),Y1(:,1),'y.');hold on;
scatter3(Cen(1,3),Cen(1,2),Cen(1,1),'bo');hold on;
scatter3(Y2(:,3),Y2(:,2),Y2(:,1),'g.');hold on;
scatter3(Cen(2,3),Cen(2,2),Cen(2,1),'bo');hold on;
scatter3(Y3(:,3),Y3(:,2),Y3(:,1),'r.');hold on;
scatter3(Cen(3,3),Cen(3,2),Cen(3,1),'bo');hold on;


figure
scatter3(New_Y1(:,3),New_Y1(:,2),New_Y1(:,1),'y.');hold on;
scatter3(New_Cen(1,3),New_Cen(1,2),New_Cen(1,1),'bo');hold on;
scatter3(New_Y2(:,3),New_Y2(:,2),New_Y2(:,1),'g.');hold on;
scatter3(New_Cen(2,3),New_Cen(2,2),New_Cen(2,1),'bo');hold on;
scatter3(New_Y3(:,3),New_Y3(:,2),New_Y3(:,1),'r.');hold on;
scatter3(New_Cen(3,3),New_Cen(3,2),New_Cen(3,1),'bo');hold on;
