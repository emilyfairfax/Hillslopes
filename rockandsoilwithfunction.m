% Hillslope Diffusion Model
% 1D Profile Evolution by Soil Creep and Regolith Production
% Basic Hillslope Case
% written by Emily Fairfax
% Feb 7th 2016


%% Initialize
%Constants
rhorock = 2650; %density of rock in kg/m^3
rhosoil = 700; %density of soil inkg/m^3
k = .001; %hillslope diffusivity constant in meter^2/yr
z0 = 0; %initial height of incising channels at boundary
erate0 = .6*10^-6; %initial incision rate of channels at boundary m/yr
period = 100000; %period of incision oscillation
a = 0.005; %steepness factor on initial topography
hstar = 0.5; %weathering parameter, scale the exponential decline of weathering rate, meters
A0 = 5*10^-6; %weathering parameter, meters/yr
A1 = 30*10^-6; %weathering parameter, meters/yr
b = 100*10^-6; %weathering parameter, meters/meter/yr
amp = 50;%amplitude of triangle wave topography
p = 100;%period of triangle wave topography, equal to amp for one wave   
    
%Time and Space Arrays: Note parameters are very sensitive and model blows up easily 
    %Time
    dt = 1000; % time step in years
    tmax = 40*10^6;% maximum time to run the code in years
    t = 0:dt:tmax;% set up the time array
    imax = length(t);% define imax for time loops 
    nplots = 100; % number of plots
    tplot = tmax/nplots; % interval between plots

    %Space
    dx = 1;   % x spacing (horizontal distance)
    xmax = p/2; % maximum x position
    x= 0:dx:xmax; % set up the space array
    xhalfs = [x(2)-dx/2:dx:x(length(x))]; 
    N=(xmax/dx)+1; % set up the number of nodes for variable array creation

%Variable Arrays
    %Bedrock Array
    Hbedrock = zeros(N:1); %set up bedrock to be length of N
    Hbedrock(1:N) = HbedrockFunction(x,xmax,amp,p); %use HbedrockFunction to import triangle wave topography

    %Soil Thickness Array
    Hinitial = zeros(N:1); %set up initial soil thickness to be length of N
    Hinitial(1:N) =0; %initial soil condition of no starting soil

    %Height of total initial condition: soil plus bedrock at t=0
    initialcondition(1:N) = Hbedrock(1:N) + Hinitial(1:N);

    %Height of total profile: soil plus bedrock to be updated in time loop
    H = zeros(N:1); %set up total height to be length of N
    H(1:N)=Hbedrock(1:N) + Hinitial(1:N); %set the initial condition to be bedrock and soil at t=0

    %Create a bottom line array for use in filling plots
    bottomline=zeros(N:1); %needs to be same length as N
    bottomline(1:N)=-200000; %arbitrary very negative number

%% Run
%Set up the time loop for t=1 to length of t
for i = 1:imax
   
        %weather the bedrock to make soil
        weatherrate(1:N) = min(A1.*exp(-Hinitial(1:N)/hstar),A0 + b.*Hinitial(1:N)); %determine weather rate using humped profile
        Hbedrock(1:N) = Hbedrock(1:N) - (rhorock/rhosoil)*weatherrate(1:N)*dt;%determine change in bedrock height
        Hinitial(1:N) = (rhorock/rhosoil)*weatherrate(1:N)*dt + Hinitial(1:N); %determine change in soil height
        H(1:N) = Hbedrock(1:N) + Hinitial(1:N); %update total height
        
        %use soil profile in transport
        Q(1:N-1) = (1-exp(-Hinitial(1:N-1)/hstar))*k.*diff(H(1:N))./dx; %carry soil out of each dx box according to flux eq. for hillslope diffusion
        dhint(1:N-2) = (1/rhosoil)*(diff(Q(1:N-1))./dx).*dt; %figure out the net flux in each box
        dh(1:N) = [-erate0*dt dhint -erate0*dt]; %carry away material according to the channel incision rate at the two boundaries
        Hinitial(1:N) = Hinitial(1:N) + dh(1:N); %update the soil thickness
        H(1:N) = Hbedrock(1:N) + Hinitial(1:N); %update the total height
        
    %Plot the Results Each Time Step
    %plots are made using subplot with position commands
    if (rem(t(i),tplot)==0)
        figure(1)
        clf;
        subplot('position',[.1 .5 .8 .45]);
        plot(x,initialcondition,'x')
        hold all
        plot(x,Hbedrock,'g')
        plot(x,H,'r')

        %Fill the soil
        uu = [x,x];        % repeat x values
        rr = [H,bottomline];   % vector of upper & lower boundaries
        fill(uu,rr,[.855,.929,.855]) %fill the created polygon

        %Fill the bedrock
        xx = [x,x];        % repeat x values
        yy = [Hbedrock,bottomline];   % vector of upper & lower boundaries
        fill(xx,yy,[.192,.396,.192]) %fill the created polygon

        %Plot formatting
        title('Profile Evolution');
        xlabel('distance along profile,m');
        ylabel('elevation,m');
        ht=text(3,40,['  ',num2str(round(t(i)/1000000)), ' Myr  '],'fontsize',18); %print time in animation
        set(gca,'fontsize',12,'fontname','arial')
        legend('Initial Condition')
        axis([0 xmax 0 amp+2])

        %Make a subplot of the flux of soil
        subplot('position',[.1 .1 .8 .1]);
        plot(xhalfs,abs(Q),'b')
        title('Flux with time');
        xlabel('distance along profile,m');
        ylabel('flux,m^2');
        axis([0 xmax 0 6*k])
        hold all;

        %Make a subplot of the soil thickness
        subplot('position',[.1 .3 .8 .1])
        plot(x,Hinitial,'m')
        title('Soil Thickness');
        xlabel('distance along profile,m');
        ylabel('soil thickness');
        axis([0 xmax 0 10*hstar])

        pause(0.02)
        hold off
    end
end
