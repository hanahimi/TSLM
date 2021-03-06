im_folder='e:/fcfm/bag1seg/';
im_dir=dir([im_folder '*.png']);

%features=struct([]);
features(length(im_dir))=SemanticFeature();


%[a,b]=textread('e:/fcfm/bag2seg/gps2.txt','%s %f');
[a,b]=textread('e:/fcfm/bag1seg/gps2.txt','(%f, %f)');
lat_base=a;%b(1:2:end);
lon_base=b;%b(2:2:end);

gps_estimated=zeros(length(im_dir),2);

gps_estimated(:,1)=interp1(lat_base,1:(length(lat_base)-1)/(length(im_dir)-1):length(lat_base));
gps_estimated(:,2)=interp1(lon_base,1:(length(lon_base)-1)/(length(im_dir)-1):length(lon_base));

%plot(gps_estimated(:,1),gps_estimated(:,2));

parfor I=1:length(im_dir)
    I
    im_base=imread([im_folder im_dir(I).name]);
    im=im_base(65:end,373:(372+1280),:);
    %imshow(im);
    im_label=colorToLabel(im);
    [~,w]=size(im_label);
    features(I).h1=hist(reshape(double(im_label(:,1:floor(w/3))),[],1),0:34);
    features(I).h2=hist(reshape(double(im_label(:,ceil(w/3):floor(2*w/3))),[],1),0:34);
    features(I).h3=hist(reshape(double(im_label(:,ceil(2*w/3):end)),[],1),0:34);
    features(I).gps=gps_estimated(I,:);
    if I==1
        features(I).d=0;
    else
        [features(I).d,~]=lldistkm(gps_estimated(I-1,:),gps_estimated(I,:));
    end;
    
end;


%% Revisar GPS:
clf;
figure(1);
h=plot(lon_base,lat_base);
plot_google_map
delete(h);
for I=1:50:length(im_dir)
    
    imshow(imread([im_folder(1:end-4) '/' im_dir( I ).name]));
    
    pause
    
end;

lat_base
lon_base

