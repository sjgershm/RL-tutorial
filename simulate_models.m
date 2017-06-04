function simulate_models(sim)
    
    % Simulate models
    %
    % USAGE: simulate_models(sim)
    %
    % INPUTS:
    %   sim - which simulation to run:
    %           'second-order conditioning' (TD and KTD models)
    %           'forward blocking' (RW and KRW models)
    %           'backward blocking' (RW and KRW models)
    %
    % Sam Gershman, June 2017
    
    switch sim
        
        case 'second-order conditioning'
            
            % construct stimuli
            nTrials = 10;       % number of trials
            trial_length = 5;
            s1 = zeros(trial_length,2);
            s1(:,2) = construct_stimulus(struct('trial_length',trial_length,'onset',2,'dur',1));  % B->+
            x1 = construct_CSC(s1); % complete serial compound representation
            r1 = construct_stimulus(struct('trial_length',trial_length,'onset',2,'dur',1));
            s2 = construct_stimulus(struct('trial_length',trial_length,'onset',[1 2],'dur',[1 1]));  % A->B->-
            x2 = construct_CSC(s2);
            r2 = zeros(trial_length,1);
            x3 = x1;    % B->-
            r3 = r2;
            X = [repmat(x1,nTrials,1); repmat(x2,nTrials,1); repmat(x3,nTrials,1)];
            r = [repmat(r1,nTrials,1); repmat(r2,nTrials,1); repmat(r3,nTrials,1)];
            
            % run models
            model_TD = TD(X,r);
            model_KTD = KTD(X,r);
            for n=1:length(model_TD)
                w_TD(n,:) = model_TD(n).w;
                w_KTD(n,:) = model_KTD(n).w;
            end
            
            % plot weights
            plot(w_TD(2*nTrials*trial_length+1:trial_length:end,[1 trial_length+2]),'LineWidth',3); hold on;
            plot(w_KTD(2*nTrials*trial_length+1:trial_length:end,[1 trial_length+2]),'--','LineWidth',3);
            xlabel('Extinction trial','FontSize',25);
            ylabel('Weight','FontSize',25);
            set(gca,'FontSize',25);
            legend({'A (TD)' 'B (TD)' 'A (KTD)' 'B (KTD)'},'FontSize',25);
            
        case 'forward blocking'
            
            % construct stimuli
            nTrials = 10;       % number of trials
            X = [repmat([1 0],nTrials,1); repmat([1 1],nTrials,1)];
            r = ones(nTrials*2,1);
            
            % run models
            model_RW = RW(X,r);
            model_KRW = KRW(X,r);
            
            % plot weights
            for n=1:length(model_RW)
                w_RW(n,:) = model_RW(n).w;
                w_KRW(n,:) = model_KRW(n).w;
            end
            plot(w_RW,'LineWidth',3); hold on;
            plot(w_KRW,'--','LineWidth',3);
            xlabel('Trial','FontSize',25);
            ylabel('Weight','FontSize',25);
            set(gca,'FontSize',25);
            legend({'A (RW)' 'B (RW)' 'A (KRW)' 'B (KRW)'},'FontSize',25);
            
        case 'backward blocking'
            
            % construct stimuli
            nTrials = 10;       % number of trials
            X = [repmat([1 1],nTrials,1); repmat([1 0],nTrials,1)];
            r = ones(nTrials*2,1);
            
            % run models
            model_RW = RW(X,r);
            model_KRW = KRW(X,r);
            
            % plot weights
            for n=1:length(model_RW)
                w_RW(n,:) = model_RW(n).w;
                w_KRW(n,:) = model_KRW(n).w;
            end
            plot(w_RW,'LineWidth',3); hold on;
            plot(w_KRW,'--','LineWidth',3);
            xlabel('Trial','FontSize',25);
            ylabel('Weight','FontSize',25);
            set(gca,'FontSize',25);
            legend({'A (RW)' 'B (RW)' 'A (KRW)' 'B (KRW)'},'FontSize',25);
            
    end