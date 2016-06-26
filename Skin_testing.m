test_img=imread('Aaron_Peirsol_0004.jpg');
cross=strrep('Aaron_Peirsol_0004.jpg','.jpg','.ppm');
cross_img=imread(cross);
%figure,imshow(cross_img);
test_img_ycbcr =rgb2ycbcr(test_img);
g1=(test_img_ycbcr (:,:,2)<135 & test_img_ycbcr (:,:,2)>75) &( test_img_ycbcr (:,:,3)<180 & test_img_ycbcr (:,:,3)>130) ;%PAPER中的第一階段，快速篩選
figure,imshow(g1,[]),title('第一階段篩選 binary pic');

run_img=double(test_img);
    
test_img1(:,:,1)=(double(g1).*run_img(:,:,1));
test_img1(:,:,2)=(double(g1).*run_img(:,:,2));
test_img1(:,:,3)=(double(g1).*run_img(:,:,3));%把第一階段篩選的影像和原圖做and，篩選出膚色部分
r_img=double(reshape(test_img1,size(test_img1,1)*size(test_img1,2),3));

%New_Cen=[New_Cen(1),New_Cen(2),New_Cen(3)];
%New_C=[New_C,New_C,New_C];
for i=1:size(r_img,1)
        for k=1:3
            %(Y2(i,:)-Cen(1,:))*inv(C(1))*(Y2(i,:)-Cen(1,:))'
             m_in(k)=(r_img(i,:)-New_Cen(k))*inv(New_C(k))*(r_img(i,:)-New_Cen(k))';%測試影像每個像素的馬氏距離
        end
        minput(i)=min(m_in);%取最小的馬氏距離
    
end

%mean_M=mean(New_M)
minput=reshape(minput,size(run_img,1),size(run_img,2));%把做好的馬氏距離還原成影像的維度
out_i=(minput(:,:)<max(max(New_M)));%經過第二階段馬氏距離篩選，要小於train出來的馬氏距離平均值(相當於一個門檻值)
     
%out_i=double(g1)-out_i;
figure,imshow(out_i),title('第二階段篩選 binary pic');
total_and=bitand(out_i,(cross_img(:,:,2)~=0));
recall=size(find(total_and))/size(find(cross_img(:,:,2)~=0));
precision = size(find(total_and))/size(find(out_i));
   
figure,imshow(uint8(test_img1),[]),title('第一階段篩選 原圖');


test_img1(:,:,1)=(double(out_i).*run_img(:,:,1));%經過第二次篩選與原圖做and
test_img1(:,:,2)=(double(out_i).*run_img(:,:,2));
test_img1(:,:,3)=(double(out_i).*run_img(:,:,3));
figure,imshow(uint8(test_img1),[]),title([' precision = ', num2str(precision) ,'  recall=',num2str(recall)]);


