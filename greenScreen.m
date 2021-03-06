clear all;
A1 = imread ('greenScreen.jpg');
C = A1;
A2 = rgb2hsv(A1);
row=size(A2)(1);
col=size(A2)(2);

A=uint8(255*A2(:,:,1));
threshold=100;
A3=0;
for i=1:row
  for j=1:col
  if A(i,j)>threshold 
    A3(i,j)=1;
  else 
    A3(i,j)=0;
  end
  end
end
imwrite(A3,'greenScreen_Hmask.jpg');

A=uint8(255*A2(:,:,2));
for i=1:row
  for j=1:col
  if A(i,j)>threshold 
    A4(i,j)=1;
  else 
    A4(i,j)=0;
  end
  end
end
imwrite(A4,'greenScreen_Smask.jpg');

Amsk=0;
Amsk= (A3.*A4);
imwrite(255*Amsk,'greenScreenFullMask.jpg');

A=A2(:,:,3);
imwrite(A,'greenScreenV.jpg');

A1(:,:,1)=Amsk.*A1(:,:,1);
A1(:,:,2)=Amsk.*A1(:,:,2);
A1(:,:,3)=Amsk.*A1(:,:,3);
imwrite(A1,'greenScreenMasked.jpg');

A = imread('greenScreenMasked.jpg');
B = imread('backGround.jpg');

row = size(A1)(1);
col = size(A1)(2);

brow = size(B)(1);
bcol = size(B)(2);

x=1;
y=1;
for i=2:row
  for j=2:col
    if A1(i,j,2) > 20 && y < bcol
      A1(i,j,1) = B(x,y,1);
      A1(i,j,2) = B(x,y,2);
      A1(i,j,3) = B(x,y,3);
      y++;
    endif
  endfor  
  if y!=1 && x < brow
    x++;
  endif
  y=1;
endfor

for i = 1:row
  for j = 1:col
    if A1(i,j,2) + A1(i,j,1) + A1(i,j,3) < 1
      A1(i,j,1) = C(i,j,1);
      A1(i,j,2) = C(i,j,2);
      A1(i,j,3) = C(i,j,3);
    endif
  endfor
endfor
imwrite(A1,'result.jpg');
