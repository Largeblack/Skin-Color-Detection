test_img=imread('Aaron_Peirsol_0004.jpg');
cross=strrep('Aaron_Peirsol_0004.jpg','.jpg','.ppm');
cross_img=imread(cross);
%figure,imshow(cross_img);
test_img_ycbcr =rgb2ycbcr(test_img);
g1=(test_img_ycbcr (:,:,2)<135 & test_img_ycbcr (:,:,2)>75) &( test_img_ycbcr (:,:,3)<180 & test_img_ycbcr (:,:,3)>130) ;%PAPER�����Ĥ@���q�A�ֳt�z��
figure,imshow(g1,[]),title('�Ĥ@���q�z�� binary pic');

run_img=double(test_img);
    
test_img1(:,:,1)=(double(g1).*run_img(:,:,1));
test_img1(:,:,2)=(double(g1).*run_img(:,:,2));
test_img1(:,:,3)=(double(g1).*run_img(:,:,3));%��Ĥ@���q�z�諸�v���M��ϰ�and�A�z��X���ⳡ��
r_img=double(reshape(test_img1,size(test_img1,1)*size(test_img1,2),3));

%New_Cen=[New_Cen(1),New_Cen(2),New_Cen(3)];
%New_C=[New_C,New_C,New_C];
for i=1:size(r_img,1)
        for k=1:3
            %(Y2(i,:)-Cen(1,:))*inv(C(1))*(Y2(i,:)-Cen(1,:))'
             m_in(k)=(r_img(i,:)-New_Cen(k))*inv(New_C(k))*(r_img(i,:)-New_Cen(k))';%���ռv���C�ӹ���������Z��
        end
        minput(i)=min(m_in);%���̤p������Z��
    
end

%mean_M=mean(New_M)
minput=reshape(minput,size(run_img,1),size(run_img,2));%�ⰵ�n������Z���٭즨�v��������
out_i=(minput(:,:)<max(max(New_M)));%�g�L�ĤG���q����Z���z��A�n�p��train�X�Ӫ�����Z��������(�۷��@�Ӫ��e��)
     
%out_i=double(g1)-out_i;
figure,imshow(out_i),title('�ĤG���q�z�� binary pic');
total_and=bitand(out_i,(cross_img(:,:,2)~=0));
recall=size(find(total_and))/size(find(cross_img(:,:,2)~=0));
precision = size(find(total_and))/size(find(out_i));
   
figure,imshow(uint8(test_img1),[]),title('�Ĥ@���q�z�� ���');


test_img1(:,:,1)=(double(out_i).*run_img(:,:,1));%�g�L�ĤG���z��P��ϰ�and
test_img1(:,:,2)=(double(out_i).*run_img(:,:,2));
test_img1(:,:,3)=(double(out_i).*run_img(:,:,3));
figure,imshow(uint8(test_img1),[]),title([' precision = ', num2str(precision) ,'  recall=',num2str(recall)]);


