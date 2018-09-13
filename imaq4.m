%clear;clc

%vid = videoinput('winvideo', 1, 'RGB24_1280x1024');
%preview(vid)
%~~~~~~~~~~~~  OR   ~~~~~~~~~~%
%if the microscope isn't working and you need a dummy image, read one from
%the workspace
%f = single(imread('get.jpg'));
%f = double(f/255);
%%%%%%%%%%%%%%%%%

%-------------------------------------------------------%       
                       
       copperyn = single(zeros(1024,1280));
       r = single(zeros(1024,1280,3));
       p = single([.4820 .4040 .3333]); %those last 3 numbers are NOT coordinates. They are level values for red, green, and blue, which make all the colors just by sliding up and down w.r.t. each other.

       %loop below after arm has placed piece under mscope
       
       f = single(getsnapshot(vid))/255;
       
       for a = 1:1024;
           for b = 1:1280; %<^scan the whole picture
               q = reshape(f(a,b,:),1,3);
               if abs(p - q) <= .018  %threshold
               copperyn(a,b) = 1;
               end
           end
       end
      
       if(sum(sum(copperyn))) >= 2   %GNG threshold
           [y_p,x_p] = find(copperyn);
           imwrite(f,'hey.jpg')
           imshow('hey.jpg'); hold on;
           plot(x_p,y_p,'o')
           print('cuprous','-djpeg')
       end