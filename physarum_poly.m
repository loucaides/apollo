function physarum_poly()
%% By E.G. Loukaides
% Loosely based on this paper by Jeff Jones
% https://doi.org/10.1162/artl.2010.16.2.16202
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ns = 2; %number of steps
gs = 1000; % grid size
sa = pi/4; % sensor angle
so = 18; % sensor offset
ra = pi/6; % rotation angle
ss = 4; % step size
n = 10000; % number of agents 
depr = 20; % deposit rate
decr = 0.8; % decay rate 
colr = parula; % colormap (try hot, winter, summer, autumn, ...)
fr = 30.; % frame rate for gif
%%
trail = zeros(gs);
ha = rand(n,1).*2*pi; % heading angles
x = rand(n,1).*gs;
y = rand(n,1).*gs;
h = 1/3*ones(3,1);
H = h*h';
figure('Position',[200,50,1000,800]);
filename = 'sample.gif';
for i=1:ns
    % sense 
    x1 = mod(x + so.*sin(ha-sa),gs);
    x2 = mod(x + so.*sin(ha),gs);
    x3 = mod(x + so.*sin(ha+sa),gs);
    y1 = mod(y + so.*cos(ha-sa),gs);
    y2 = mod(y + so.*cos(ha),gs);
    y3 = mod(y + so.*cos(ha+sa),gs);
    % value of three sensors for each agent
    idx1 = sub2ind([gs,gs], ceil(x1), ceil(y1));
    idx2 = sub2ind([gs,gs],  ceil(x2), ceil(y2));
    idx3 = sub2ind([gs,gs],  ceil(x3), ceil(y3));
    s1 = trail(idx1); s2 = trail(idx2); s3 = trail(idx3);
    % decide rotation according to sensor values
    ri = (s2<s1) & (s2<s3);
    ha(ri)= ha(ri) +ra.*(-1).^(floor(rand(size(ha(ri))).*2));
    ri = (s1>s2) & (s2>s3);
    ha(ri) = ha(ri)-ra;
    ri = (s3>s2)  & (s2>s1);
    ha(ri)= ha(ri)+ ra;
    % move
    x = mod(x + ss.*sin(ha),gs);
    y = mod(y + ss.*cos(ha),gs);
    idxd = sub2ind([gs,gs], ceil(x),ceil(y));
    % deposit
    trail(idxd) = trail(idxd) + depr;  
    % diffuse & decay
    trail = decr.*filter2(H,trail);
    %%
    % plot
    image(trail.*50.);
    axis tight manual equal off% 
    colormap(colr);
    % Capture the plot as an image 
    ax = gca;
    ax.Units = 'pixels';
    frame = getframe(ax);
    ax.Units = 'normalized'; 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if i == 1 
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1/fr); 
    else 
      imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1/fr); 
    end 
    pause(.01);
end
end
