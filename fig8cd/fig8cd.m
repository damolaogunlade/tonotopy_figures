%% This function simulates the response of pRFs to a stimulus (frequency) and determines how well the stimulus can be decoded based on parameters of the pRF model (mu, sigma)

%% Define variables
% List of hemispheres
hemis = ["lh","rh"];

% List of ages
ages = ["adults","kids"];

% Plotting colors
load("plotting_colors.mat");

colors = [adult_colors(1,:);adult_colors(6,:)];

% Create an array of frequencies
freqs = [88	125	150 177	250	354	500	707	1000	1414	2000	2828	4000	5657	8000];

%% Determine adult and child mean sigma in low mu voxels 
roi = "pac"; 
if strcmp(roi,"pac")
    adults_mean_sigma_low = 278.0556; %pac
    kids_mean_sigma_low = 210.1806; %pac
end
% Create array of tuning width parameters based on experimental sigma 
sigma_arr = [adults_mean_sigma_low kids_mean_sigma_low];
%% Determine adult and child mean cochleotopic coverage
load(sprintf("%s_cochleotopy_avg_across_hemis.mat",roi))
adults_mean_prf = mean(cochleotopy_adults,"omitnan");
kids_mean_prf =  mean(cochleotopy_kids,"omitnan");
pRF_arr = [adults_mean_prf; kids_mean_prf];
simulated_prf_cov_txt = [sprintf("Simulated Adult pRF Coverage (σ = %0.2f Hz)",sigma_arr(1)), sprintf("Simulated Kid pRF Coverage (σ = %0.2f Hz)",sigma_arr(2))];
%% Simulate pRFs
f = figure;

% Define a population of pRFs 
num_vertices = 1000;


% Create array of noise parameters
noise_arr = linspace(0.01,0.1,10);
% noise_arr = linspace(0,1,11);

% Number of iterations over which to determine decoding error 
n_its = 1000;

% Initalize matrix of decoding error for each sigma value across iterations
mean_err = zeros(n_its, length(noise_arr),length(sigma_arr));

% Initialize simulated pRF coverage for each sigma value 
simulated_pRF_cov = zeros(length(sigma_arr),length(freqs));

% Loop through each target frequency
for f = 3 % 150 Hz tone

    for k = 1:length(noise_arr)

        % Loop through each sigma value
        for s = 1:length(sigma_arr)

            % Generate distribution of muvals which results in pRF
            % coverage plot that most closely matches observed pRF
            % coverage plot
            mu_grid = exp(linspace(log(min(freqs)), log(max(freqs)), num_vertices));

            % Generate matrix of pRFs centered at each of these mu values
            K = exp(-(freqs(:) - mu_grid).^2/(2*sigma_arr(s)^2));
            % K = exp(-(freqs(:) - mu_grid).^2./(2*sigmavals.^2)); % pRFs centered at all possible mu values

            % Experimental pRF coverage
            Gexp = pRF_arr(s,:);

            % Perform least squares to determine the weights w that satistfy: K*w = Gexp
            % K = matrix consisting of pRFs centered at all possible mu values
            % Gexp = experimental pRF
            % w = weights/probability distribution of mu values that when multiplied by K, best approximate Gexp
            % We want the weights (w) sum to 1 because they represent the
            % probability distribution of mu values
            % To specify that the w components sum to 1, use Aeq = ones(1,N) and beq = 1
            Aeq = ones(1,length(mu_grid));
            beq = 1;
            lb = zeros(length(mu_grid),1); % lower bounds of w components
            w = lsqlin(K, Gexp, [], [], Aeq, beq, lb, []);

            % Sample mu values based on fitted weights
            idx = randsample(numel(mu_grid), num_vertices, true, w);
            muvals = mu_grid(idx);
            muvals = muvals';

            % Initialize matrix of simulated pRFs for each iteration 
            mean_pRF = zeros(n_its,size(Gexp,2));

            % Loop through each iteration
            for n = 1:n_its

                % Calculate the Gaussian value at each frequency for each vertex
                [F,M] = meshgrid(freqs,muvals);
                % [F,M] = meshgrid(freqs,mu_grid);
                pRFs = exp(-(F-M).^2 ./ (2*sigma_arr(s)^2));
                % pRFs = exp(-(F-M).^2 ./ (2*sigmavals'.^2));

                % Determine pRF response (Gaussian value at given
                % frequency)
                target_freq = freqs(f);
                responses = pRFs(:,f);

                % Add Gaussian white noise
                noise_factor = noise_arr(k);  % e.g., 0.1 --> addition of noise with 10% SD of mean response 
                sigma_noise = noise_factor * mean(abs(responses));
                responses = responses + sigma_noise * randn(size(responses));

                % Weight preferred frequencies by responses to
                % determine predicted frequency
                weighted_avg = sum(muvals.*responses)/sum(responses);
                pred_freq = weighted_avg;

                % Calculate decoding error
                err = abs(pred_freq-target_freq);
                mean_err(n,k,s) = err;

                % Save the mean pRF for the current iteration
                mean_pRF(n, :) = mean(pRFs, 1);


            end

            % Plot pRF coverage
            if k==1 % no noise 
                simulated_pRF_cov(s,:) = mean(mean_pRF,1);
                plot(simulated_pRF_cov(s,:),'DisplayName',simulated_prf_cov_txt(s),"LineStyle","--",'LineWidth',2,'Color',colors(s,:))
                hold on;
                xticks(1:length(freqs))
                xticklabels(freqs)
                xlabel("Frequency (Hz)")
                ylabel("Mean Probability Density")
                roi_txt = roi; 
                if strcmp(roi,"pac")
                    roi_txt = "PAC";
                end
                % title(sprintf("Simulated vs Observed Mean %s pRF Coverage",roi_txt))
            end

        end

    end
end
avg_err = squeeze(mean(mean_err,1));

% Plot actual pRF coverage
hold on;
plot(adults_mean_prf,"DisplayName", "Observed Adult Mean pRF Coverage","LineStyle","-","LineWidth",2,'Color',colors(1,:))
hold on;
plot(kids_mean_prf,"DisplayName", "Observed Kid Mean pRF Coverage","LineStyle","-","LineWidth",2,'Color',colors(2,:))
% legend("Box","off","FontSize",10)
hold on; 

% Calculate R2
SSres = sum((adults_mean_prf- simulated_pRF_cov(1,:)).^2);
SStot = sum((adults_mean_prf-mean(adults_mean_prf)).^2);
R2 = 1 - SSres/SStot;
% text(12,0.35,sprintf("R^2 = %0.2f",R2),"Color",colors(1,:),"FontSize",10)
sprintf("Adults Observed vs Simulated pRF Coverage: R2 = %0.2f",R2)
SSres = sum((kids_mean_prf- simulated_pRF_cov(2,:)).^2);
SStot = sum((kids_mean_prf-mean(kids_mean_prf)).^2);
R2 = 1 - SSres/SStot;
sprintf("Kids Actual vs Observed pRF Coverage: R2 = %0.2f",R2)
% text(12,0.33,sprintf("R^2 = %0.2f",R2),"Color",colors(2,:),"FontSize",10)
% Formatting
ax = gca;
set(ax,"FontSize",14,"FontName","Arial",'Tickdir','out','LineWidth',1)
box off

% Save plot
fig = gcf;
fig.Position(3:4) = [500, 350];
exportgraphics(fig, sprintf("%s_SimulatedPRF.png",roi),'Resolution',300);

% %% 2D plot of decoding error as function of sigma and noise factor
% figure
% imagesc(noise_arr, sigma_arr, (avg_err))
% axis xy
% xlabel('Noise SD')
% ylabel('Sigma (Hz)')
% yticks(sigma_arr)
% yticklabels(sigma_arr)
% set(gca,"YScale","log")
% cb = colorbar;
% % clim([15,65])
% ylabel(cb, 'Mean Decoding Error (Hz)')
% title("pRF Decoding Error for 150 Hz Tone")
% ax = gca;
% ax.YMinorTick = 'off';

%% Plot decoding error in "Adult" and "Kid" pRF populations
figure;
shadedErrorBar(1:length(noise_arr),mean_err(:,:,1), {@mean,@std}, ...
    'lineProps', {'-', 'Color', colors(1,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
% plot(avg_err(:,1),'LineWidth',2,'Color',colors(1,:))
hold on;
shadedErrorBar(1:length(noise_arr),mean_err(:,:,2), {@mean,@std}, ...
    'lineProps', {'-', 'Color', colors(2,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
% plot(avg_err(:,2),'LineWidth',2,'Color',colors(2,:))
% legend("Adults", "Kids",...
%     "FontSize",10,"Box","off")
% legend([sprintf("Adults: Mean Sigma = %0.2f Hz",mean(adults_sigma)),sprintf("Kids: Mean Sigma = %0.2f Hz",mean(kids_sigma))])
xticks([1:length(noise_arr)])
xticklabels(noise_arr)
xlabel("Noise Factor")
ylabel("Decoding Error (Hz)")
xlim([1, 11])
% title(sprintf("%s pRF Decoding Error for %i Hz Tone",roi_txt,freqs(f)))

% Formatting
ax = gca;
set(ax,"FontSize",14,"FontName","Arial",'Tickdir','out','LineWidth',1)
box off

% Save plot
fig = gcf;
fig.Position(3:4) = [500, 350];
exportgraphics(fig, sprintf("%s_pRFDecodingErr.png",roi),'Resolution',300);

%% Perform 2-way ANOVA (age x noise) to test difference in decoding error between adults and children 


T = table();
T.Age = [repmat("adults",1,size(mean_err,1)*size(mean_err,2)),repmat("kids",1,size(mean_err,1)*size(mean_err,2))]'; 
T.Age = categorical(T.Age);
T.Noise = repmat(noise_arr,1,size(mean_err,1)*size(mean_err,3))';
T.Decoding_Error = mean_err(:);
[iter, noiseIdx, sigmaIdx] = ndgrid( ...
    1:n_its, ...
    1:length(noise_arr), ...
    1:length(sigma_arr));
T.Iteration = iter(:);

% Fit linear mixed effects model
lme = fitlme(T, ...
    'Decoding_Error ~ Age*Noise + (1|Iteration)');
anova(lme)