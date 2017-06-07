function exercises(exercise)
    
    % Exercise solutions
    %
    % USAGE: exercises(exercise)
    %
    % INPUTS:
    %   sim - which simulation to run:
    %           'latent inhibition' (RW and KRW models)
    %           'delay conditioning' (TD model)
    %
    % Sam Gershman, June 2017
    
    switch exercise
        
        case 'latent inhibition'
            
            % construct stimuli
            nTrials = 10;       % number of trials
            X_pre = ones(2*nTrials,1);
            X_nopre = [zeros(nTrials,1); ones(nTrials,1)];
            r = [zeros(nTrials,1); ones(nTrials,1)];
            X_pre_delay = [ones(nTrials,1); zeros(nTrials,1); ones(nTrials,1)];
            r_delay = [zeros(nTrials*2,1); ones(nTrials,1)];
            X_nopre_delay = [zeros(2*nTrials,1); ones(nTrials,1)];
            
            % run models
            model_RW_pre = RW(X_pre,r);
            model_KRW_pre = KRW(X_pre,r);
            model_RW_nopre = RW(X_nopre,r);
            model_KRW_nopre = KRW(X_nopre,r);
            model_KRW_pre_delay = KRW(X_pre_delay,r_delay);
            model_KRW_nopre_delay = KRW(X_nopre_delay,r_delay);
            
            % plot weights: no delay
            for n=1:nTrials*2
                w_RW(n,:) = [model_RW_pre(n).w model_RW_nopre(n).w];
                w_KRW(n,:) = [model_KRW_pre(n).w model_KRW_nopre(n).w];
            end
            figure;
            plot(w_RW,'LineWidth',3); hold on;
            plot(w_KRW,'--','LineWidth',3);
            xlabel('Trial','FontSize',25);
            ylabel('Weight','FontSize',25);
            set(gca,'FontSize',25);
            legend({'RW (pre)' 'RW (nopre)' 'KRW (pre)' 'KRW (nopre)'},'FontSize',25);
            
            % plot weights: delay
            for n=1:nTrials*3
                w_KRW_delay(n,:) = [model_KRW_pre_delay(n).w model_KRW_nopre_delay(n).w];
            end
            figure;
            LI = [w_KRW(end,2)-w_KRW(end,1) w_KRW_delay(end,2)-w_KRW_delay(end,1)];
            bar(LI); colormap bone
            ylabel('Latent inhibition effect (nopre-pre)','FontSize',25);
            set(gca,'FontSize',25,'XTickLabel',{'No Delay' 'Delay'});
            
        case 'delay conditioning'
            
            % construct stimuli
            nTrials = 10;       % number of trials
            trial_length = 8;
            s = construct_stimulus(struct('trial_length',trial_length,'onset',1,'dur',5));  % A->+
            x = construct_CSC(s); % complete serial compound representation
            r = construct_stimulus(struct('trial_length',trial_length,'onset',5,'dur',1));
            X = repmat(x,nTrials+1,1);
            r = [repmat(r,nTrials,1); zeros(trial_length,1)];
            
            % run model
            model = TD(X,r);
            
            % plot TD error
            dt = [model.dt];
            dt = reshape(dt,trial_length,nTrials+1)';
            figure; imagesc(dt(1:end-1,:)); colormap hot; colorbar
            xlabel('Timestep','FontSize',25);
            ylabel('Trial','FontSize',25);
            set(gca,'FontSize',25,'XTick',1:trial_length,'YTick',1:nTrials);
            title('TD error','FontSize',25);
            
            % plot omission response
            figure; plot(dt(end,:),'LineWidth',3);
            xlabel('Timestep','FontSize',25);
            ylabel('TD error','FontSize',25);
            set(gca,'FontSize',25,'XTick',1:trial_length);
            title('Omission response','FontSize',25);
    end